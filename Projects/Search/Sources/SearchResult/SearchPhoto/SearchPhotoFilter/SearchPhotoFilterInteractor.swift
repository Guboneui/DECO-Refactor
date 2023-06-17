//
//  SearchPhotoFilterInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/16.
//

import Util
import Entity

import RIBs
import RxSwift
import RxRelay

protocol SearchPhotoFilterRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchPhotoFilterPresentable: Presentable {
  var listener: SearchPhotoFilterPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchPhotoFilterListener: AnyObject {
  func dismissFilterModalVC()
}

final class SearchPhotoFilterInteractor: PresentableInteractor<SearchPhotoFilterPresentable>, SearchPhotoFilterInteractable, SearchPhotoFilterPresentableListener {
  
  weak var router: SearchPhotoFilterRouting?
  weak var listener: SearchPhotoFilterListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let searchPhotoFilterManager: MutableSearchPhotoFilterStream

  var boardCategoryList: BehaviorRelay<[(category: BoardCategoryDTO, isSelected: Bool)]> = .init(value: [])
  var moodCategoryList: BehaviorRelay<[(category: ProductMoodDTO, isSelected: Bool)]> = .init(value: [])
  var colorCategoryList: BehaviorRelay<[(color: ProductColorModel, isSelected: Bool)]> = .init(value: [])
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: SearchPhotoFilterPresentable,
    searchPhotoFilterManager: MutableSearchPhotoFilterStream
  ) {
    self.searchPhotoFilterManager = searchPhotoFilterManager
    super.init(presenter: presenter)
    presenter.listener = self
    
    let boardCategoryList = searchPhotoFilterManager.categoryList
    let moodCategoryList = searchPhotoFilterManager.moodList
    let colorCategoryList = searchPhotoFilterManager.colorList
    
    searchPhotoFilterManager.selectedFilter
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let selectedBoardCategoryIds: [Int] = filter.selectedCategory.map{$0.id}
        let currentBoardCategoryList = boardCategoryList.map{($0, selectedBoardCategoryIds.contains($0.id))}
        
        let selectedMoodCategoryIds: [Int] = filter.selectedMood.map{$0.id}
        let currentMoodCategoryList = moodCategoryList.map{($0, selectedMoodCategoryIds.contains($0.id))}
        
        let selectedColorCategoryIds: [Int] = filter.selectedColors.map{$0.id}
        let currentColorCateogryList = colorCategoryList.map{($0, selectedColorCategoryIds.contains($0.id))}
        
        self.boardCategoryList.accept(currentBoardCategoryList)
        self.moodCategoryList.accept(currentMoodCategoryList)
        self.colorCategoryList.accept(currentColorCateogryList)
      }).disposed(by: disposeBag)
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissFilterModalVC() {
    listener?.dismissFilterModalVC()
  }
  
  func updateSearchPhotoSelectedFilterStream(
    categoryList: [BoardCategoryDTO],
    moodList: [ProductMoodDTO],
    colorList: [ProductColorModel]
  ) {
    searchPhotoFilterManager.updateFilterStream(
      category: categoryList,
      mood: moodList,
      color: colorList
    )
  }
}
