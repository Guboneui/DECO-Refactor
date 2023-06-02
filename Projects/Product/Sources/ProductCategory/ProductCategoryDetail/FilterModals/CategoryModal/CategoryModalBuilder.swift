//
//  CategoryModalBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs

protocol CategoryModalDependency: Dependency {
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream { get }
}

final class CategoryModalComponent: Component<CategoryModalDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CategoryModalBuildable: Buildable {
  func build(withListener listener: CategoryModalListener) -> CategoryModalRouting
}

final class CategoryModalBuilder: Builder<CategoryModalDependency>, CategoryModalBuildable {
  
  override init(dependency: CategoryModalDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: CategoryModalListener) -> CategoryModalRouting {
    let component = CategoryModalComponent(dependency: dependency)
    let viewController = CategoryModalViewController()
    let interactor = CategoryModalInteractor(
      presenter: viewController,
      selectedFilterInProductCategory: dependency.selectedFilterInProductCategory
    )
    interactor.listener = listener
    return CategoryModalRouter(interactor: interactor, viewController: viewController)
  }
}
