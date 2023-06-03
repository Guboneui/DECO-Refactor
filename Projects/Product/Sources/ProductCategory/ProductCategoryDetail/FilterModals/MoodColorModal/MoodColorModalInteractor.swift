//
//  MoodColorModalInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift
import RxRelay

protocol MoodColorModalRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MoodColorModalPresentable: Presentable {
  var listener: MoodColorModalPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MoodColorModalListener: AnyObject {
  func dismissMoodColorModalVC()
}

final class MoodColorModalInteractor: PresentableInteractor<MoodColorModalPresentable>, MoodColorModalInteractable, MoodColorModalPresentableListener {
  
  weak var router: MoodColorModalRouting?
  weak var listener: MoodColorModalListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  
  var moodList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> = .init(value: [])
  
  init(
    presenter: MoodColorModalPresentable,
    selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  ) {
    self.selectedFilterInProductCategory = selectedFilterInProductCategory
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    let moodList = selectedFilterInProductCategory.productMoodList.map{($0, false)}
    self.moodList.accept(moodList)
    
//    selectedFilterInProductCategory.selectedFilter
//      .subscribe(onNext: { [weak self] filter in
//        guard let self else { return }
//        let moodList: [(ProductCategoryModel, Bool)] = filt.map{($0, false)}
//        self.moodList.accept(moodList)
//      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissMoodColorModalVC() {
    self.listener?.dismissMoodColorModalVC()
  }
}
