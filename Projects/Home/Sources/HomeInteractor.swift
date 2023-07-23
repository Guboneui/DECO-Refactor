//
//  HomeInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs
import RxSwift
import RxRelay

import Util
import Entity
import Networking

public protocol HomeRouting: ViewableRouting {
  func attachSearchVC()
  func detachSearchVC(with popType: PopType)
}

protocol HomePresentable: Presentable {
  var listener: HomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol HomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
  
  
  
  var latestBoardViewControllerable: RIBs.ViewControllable?
  var popularBoardViewControllerable: RIBs.ViewControllable?
  var followBoardViewControllerable: RIBs.ViewControllable?
  
  var boardVCs: BehaviorRelay<[ViewControllable]> = .init(value: [])
  var postingFilter: BehaviorRelay<[(filter: PostingCategoryModel, isSelected: Bool)]> = .init(value: [])
  
  weak var router: HomeRouting?
  weak var listener: HomeListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let boardRepository: BoardRepository
  private let productRepository: ProductRepository
  private let postingCategoryFilter: MutableSelectedPostingFilterStream
  
  init(
    presenter: HomePresentable,
    boardRepository: BoardRepository,
    productRepository: ProductRepository,
    postingCategoryFilter: MutableSelectedPostingFilterStream
  ) {
    self.boardRepository = boardRepository
    self.productRepository = productRepository
    self.postingCategoryFilter = postingCategoryFilter
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    if let latestBoardViewControllerable,
       let popularBoardViewControllerable,
       let followBoardViewControllerable {
      self.boardVCs.accept([latestBoardViewControllerable, popularBoardViewControllerable, followBoardViewControllerable])
    }
    
    self.fetchFilterList()
    
    postingCategoryFilter.selectedFilter
      .share()
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchFilterList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let boardFilter = await self.boardRepository.boardCategoryList(),
         let styleFilter = await self.productRepository.getProductMoodList() {
      
        let convertBoardFilter: [(PostingCategoryModel, Bool)] = boardFilter.sorted{$0.id < $1.id}.map{(PostingCategoryModel(name: $0.categoryName, id: $0.id, type: .Board), false)}
        let convertStyleFilter: [(PostingCategoryModel, Bool)] = styleFilter.sorted{$0.id < $1.id}.map{(PostingCategoryModel(name: $0.name, id: $0.id, type: .Style), false)}
        
        let all: (PostingCategoryModel, Bool) = (PostingCategoryModel(name: "전체", id: -1, type: .All), true)
        self.postingFilter.accept([all] + convertStyleFilter + convertBoardFilter)
      }
    }
  }
  
  func selectFilter(at index: Int, with filter: (PostingCategoryModel, Bool)) {
    if index == 0 {
      let clearData = makeClearData()
      self.postingFilter.accept(clearData)
      self.postingCategoryFilter.clearStream()
    } else {
      var newData = self.postingFilter.value
      newData[0].1 = false
      newData[index].1.toggle()
      
      if Array(newData[1...]).filter({$0.isSelected}).isEmpty {
        newData[0].1 = true
      }
      self.postingFilter.accept(newData)
      
      let boardCategory: [PostingCategoryModel] = self.postingFilter.value.filter{$0.filter.type == .Board && $0.isSelected}.map{$0.filter}
      let styleCategory: [PostingCategoryModel] = self.postingFilter.value.filter{$0.filter.type == .Style && $0.isSelected}.map{$0.filter}
      self.postingCategoryFilter.updateFilterStream(boardCategoryList: boardCategory, styleCategoryList: styleCategory)
    }
  }
  
  private func makeClearData() -> [(PostingCategoryModel, Bool)] {
    var clearData: [(PostingCategoryModel, Bool)] = self.postingFilter.value.map{($0.0, false)}
    clearData[0].1 = true
    return clearData
  }
  
  func pushSearchVC() {
    router?.attachSearchVC()
  }
  
  func popSearchVC(with popType: Util.PopType) {
    router?.detachSearchVC(with: popType)
  }
}
