//
//  CategoryColorModalInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import Util

import RIBs
import RxSwift
import RxRelay

protocol CategoryColorModalRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CategoryColorModalPresentable: Presentable {
  var listener: CategoryColorModalPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CategoryColorModalListener: AnyObject {
  func dismissCategoryColorModalVC()
}

final class CategoryColorModalInteractor: PresentableInteractor<CategoryColorModalPresentable>, CategoryColorModalInteractable, CategoryColorModalPresentableListener {
  
  weak var router: CategoryColorModalRouting?
  weak var listener: CategoryColorModalListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  
  var categoryList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> = .init(value: [])
  var colorList: BehaviorRelay<[(color: Util.ProductColorModel, isSelected: Bool)]> = .init(value: [])
  
  
  init(
    presenter: CategoryColorModalPresentable,
    selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  ) {
    self.selectedFilterInProductMood = selectedFilterInProductMood
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    let categoryList = selectedFilterInProductMood.productCategoryList
    let colorList = Util.ProductColorModels
    
    selectedFilterInProductMood.selectedFilter
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let selectedCategoryIds: [Int] = filter.selectedCategories.map{$0.id}
        let currentCategoryList = categoryList.map{($0, selectedCategoryIds.contains($0.id))}
        let selectedColorIds: [Int] = filter.selectedColors.map{$0.id}
        let currentColorList = colorList.map{($0, selectedColorIds.contains($0.id))}
        
        self.categoryList.accept(currentCategoryList)
        self.colorList.accept(currentColorList)
      }).disposed(by: disposeBag)
    
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissCategoryColorModalVC() {
    listener?.dismissCategoryColorModalVC()
  }
  
  func updateSelectedFilterStream(
    categoryList: [ProductCategoryModel],
    colorList: [ProductColorModel]
  ) {
    selectedFilterInProductMood.updateFilterStream(
      categories: categoryList,
      colors: colorList
    )
  }
}
