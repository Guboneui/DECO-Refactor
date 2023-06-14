//
//  MoodColorModalInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import Util

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
  var colorList: BehaviorRelay<[(color: ProductColorModel, isSelected: Bool)]> = .init(value: [])
  
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
    
    let productMoodList = selectedFilterInProductCategory.productMoodList
    let colorList = Util.ProductColorModels
    
    selectedFilterInProductCategory.selectedFilter
      .share()
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let selectedMoodIds: [Int] = filter.selectedMoods.map{$0.id}
        let currentMoodList = productMoodList.map{($0, selectedMoodIds.contains($0.id))}
        
        let selectedColorIds: [Int] = filter.selectedColors.map{$0.id}
        let currentColorList = colorList.map{($0, selectedColorIds.contains($0.id))}
        
        self.moodList.accept(currentMoodList)
        self.colorList.accept(currentColorList)
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissMoodColorModalVC() {
    self.listener?.dismissMoodColorModalVC()
  }
  
  func updateSelectedFilterStream(
    moodList: [ProductCategoryModel],
    colorList: [ProductColorModel]
  ) {
    selectedFilterInProductCategory.updateFilterStream(
      moods: moodList,
      colors: colorList
    )
  }
}
