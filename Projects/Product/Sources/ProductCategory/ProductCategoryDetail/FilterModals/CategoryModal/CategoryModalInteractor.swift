//
//  CategoryModalInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift
import RxRelay

protocol CategoryModalRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CategoryModalPresentable: Presentable {
  var listener: CategoryModalPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CategoryModalListener: AnyObject {
  func dismissCategoryModalVC()
}

final class CategoryModalInteractor: PresentableInteractor<CategoryModalPresentable>, CategoryModalInteractable, CategoryModalPresentableListener {
  
  weak var router: CategoryModalRouting?
  weak var listener: CategoryModalListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  
  var categoryList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> = .init(value: [])
  
  init(
    presenter: CategoryModalPresentable,
    selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  ) {
    self.selectedFilterInProductCategory = selectedFilterInProductCategory
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    selectedFilterInProductCategory.selectedFilter
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let currentSelectedId: Int = filter.selectedCategory?.id ?? 0
        let categoryList: [(ProductCategoryModel, Bool)] = self.selectedFilterInProductCategory.productCategoryList.map{($0, $0.id == currentSelectedId ? true : false)}
        self.categoryList.accept(categoryList)
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissCategoryModalVC() {
    self.listener?.dismissCategoryModalVC()
  }
  
  func selectedCategory(category: ProductCategoryModel, _ completion: (()->())?) {
    self.selectedFilterInProductCategory.updateSelectedCategory(category: category)
    completion?()
  }
}
