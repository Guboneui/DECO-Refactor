//
//  MoodModalInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import RIBs
import RxSwift
import RxRelay

protocol MoodModalRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MoodModalPresentable: Presentable {
  var listener: MoodModalPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MoodModalListener: AnyObject {
  func dismissMoodModalVC()
}

final class MoodModalInteractor: PresentableInteractor<MoodModalPresentable>, MoodModalInteractable, MoodModalPresentableListener {
  
  weak var router: MoodModalRouting?
  weak var listener: MoodModalListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  
  var moodList: BehaviorRelay<[(mood: ProductCategoryModel, isSelected: Bool)]> = .init(value: [])
  
  init(
    presenter: MoodModalPresentable,
    selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  ) {
    self.selectedFilterInProductMood = selectedFilterInProductMood
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    selectedFilterInProductMood.selectedFilter
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let currentSelectedId: Int = filter.selectedMood?.id ?? 0
        let moodList: [(ProductCategoryModel, Bool)] = self.selectedFilterInProductMood.productMoodList.map{($0, $0.id == currentSelectedId ? true : false)}
        self.moodList.accept(moodList)
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func selectedMood(mood: ProductCategoryModel, _ completion: (() -> ())?) {
    self.selectedFilterInProductMood.updateSelectedMood(mood: mood)
    completion?()
  }
  
  func dismissMoodModalVC() {
    self.listener?.dismissMoodModalVC()
  }
}
