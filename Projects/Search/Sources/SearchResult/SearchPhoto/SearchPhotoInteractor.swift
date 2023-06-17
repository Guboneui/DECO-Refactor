//
//  SearchPhotoInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Util
import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol SearchPhotoRouting: ViewableRouting {
  func attachFilterModalVC()
  func detachFilterModalVC()
}

protocol SearchPhotoPresentable: Presentable {
  var listener: SearchPhotoPresentableListener? { get set }
  @MainActor func showEmptyNotice(isEmpty: Bool)
  @MainActor func showFilterView()
}

protocol SearchPhotoListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchPhotoInteractor: PresentableInteractor<SearchPhotoPresentable>, SearchPhotoInteractable, SearchPhotoPresentableListener {
  
  weak var router: SearchPhotoRouting?
  weak var listener: SearchPhotoListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let searchText: String
  private let searchRepository: SearchRepository
  private let userManager: MutableUserManagerStream
  private let productRepository: ProductRepository
  private let boardRepository: BoardRepository
  private let searchPhotoFilterManager: MutableSearchPhotoFilterStream
  
  var photoList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  var selectedFilter: BehaviorRelay<[(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)]> = .init(value: [])
  
  init(
    presenter: SearchPhotoPresentable,
    searchText: String,
    searchRepository: SearchRepository,
    userManager: MutableUserManagerStream,
    productRepository: ProductRepository,
    boardRepository: BoardRepository,
    searchPhotoFilterManager: MutableSearchPhotoFilterStream
  ) {
    self.searchText = searchText
    self.searchRepository = searchRepository
    self.userManager = userManager
    self.productRepository = productRepository
    self.boardRepository = boardRepository
    self.searchPhotoFilterManager = searchPhotoFilterManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.searchPhotoCategoryStreamBinding()
    
    Task.detached { [weak self] in
      guard let self else { return }
      await self.setSearchPhotoCategoryStream()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchPhotoList(createdAt: Int) {
    searchPhotoFilterManager.selectedFilter
      .take(1)
      .subscribe(onNext: { [weak self] selectedFilter in
        guard let self else { return }
        Task.detached { [weak self] in
          guard let self else { return }
          if let photoList = await self.searchRepository.getSearchPhotoList(
            param: BoardFilterRequest(
              offset: createdAt,
              listType: "SEARCH",
              keyword: self.searchText,
              styleIds: selectedFilter.selectedMood.map{$0.id},
              colorIds: selectedFilter.selectedColors.map{$0.id},
              boardCategoryIds: selectedFilter.selectedCategory.map{$0.id},
              userId: self.userManager.userID)
          ) {
            print(photoList)
            
            let prevData = self.photoList.value
            if !photoList.isEmpty {
              self.photoList.accept(prevData + photoList)
            }
            
            if prevData.isEmpty && photoList.isEmpty {
              await self.presenter.showEmptyNotice(isEmpty: true)
            }
            
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func showFilterModalVC() {
    self.router?.attachFilterModalVC()
  }
  
  func dismissFilterModalVC() {
    self.router?.detachFilterModalVC()
  }
}

// FilterManager

extension SearchPhotoInteractor {
  private func setSearchPhotoCategoryStream() async {
    
    let boardCategory = Observable.just(await boardRepository.boardCategoryList())
    let moodCategory = Observable.just(await productRepository.getProductMoodList())
    let colorCategory = Observable.just(Util.ProductColorModels)
    
    Observable.zip(boardCategory, moodCategory, colorCategory)
      .subscribe(onNext: { [weak self] board, mood, color in
        guard let self else { return }
        if let board, let mood {
          
          self.searchPhotoFilterManager.setCategoryFilterData(categoryData: board)
          self.searchPhotoFilterManager.setMoodFilterData(moodData: mood)
          self.searchPhotoFilterManager.setColorFilterData(colorData: color)
          
          Task {
            await self.presenter.showFilterView()
          }
        }
        
      }).disposed(by: disposeBag)
  }
  
  private func searchPhotoCategoryStreamBinding() {
    searchPhotoFilterManager.selectedFilter
      .share()
      .subscribe(onNext: { [weak self] selectedFilter in
        guard let self else { return }
        let boardCategory: [(String, Int, SearchPhotoFilterType, Bool)] = selectedFilter.selectedCategory.map{($0.categoryName, $0.id, SearchPhotoFilterType.Board, true)}
        let moodCategory: [(String, Int, SearchPhotoFilterType, Bool)] = selectedFilter.selectedMood.map{($0.name, $0.id, SearchPhotoFilterType.Mood, true)}
        let colorCategory: [(String, Int, SearchPhotoFilterType, Bool)] = selectedFilter.selectedColors.map{($0.name, $0.id, SearchPhotoFilterType.Color, true)}

        if (boardCategory + moodCategory + colorCategory).isEmpty {
          self.selectedFilter.accept([])
        } else {
          self.selectedFilter.accept([("초기화", -1, SearchPhotoFilterType.None, false)] + boardCategory + moodCategory + colorCategory)
        }

        Task.detached { [weak self] in
          guard let inSelf = self else { return }
          if let photoList = await inSelf.searchRepository.getSearchPhotoList(
            param: BoardFilterRequest(
              offset: Int.max,
              listType: "SEARCH",
              keyword: inSelf.searchText,
              styleIds: selectedFilter.selectedMood.map{$0.id},
              colorIds: selectedFilter.selectedColors.map{$0.id},
              boardCategoryIds: selectedFilter.selectedCategory.map{$0.id},
              userId: inSelf.userManager.userID
            )
          ) {
            if photoList.isEmpty {
              await inSelf.presenter.showEmptyNotice(isEmpty: true)
            } else {
              inSelf.photoList.accept(photoList)
              await inSelf.presenter.showEmptyNotice(isEmpty: false)
            }
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func updateFilter(
    cateogryList: [(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)],
    moodList: [(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)],
    colorList: [(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)]
  ) {
    let category: [BoardCategoryDTO] = cateogryList.map{BoardCategoryDTO(categoryName: $0.name, id: $0.id)}
    let mood: [ProductMoodDTO] = moodList.map{ProductMoodDTO(id: $0.id, url: "", name: $0.name)}
    let color: [ProductColorModel] = colorList.map{ProductColorModel(name: $0.name, image: Util.getColorImage(id: $0.id), id: $0.id)}
    self.searchPhotoFilterManager.updateFilterStream(category: category, mood: mood, color: color)
  }
}
