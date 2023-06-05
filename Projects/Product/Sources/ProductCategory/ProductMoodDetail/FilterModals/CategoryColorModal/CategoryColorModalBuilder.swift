//
//  CategoryColorModalBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//


import RIBs

protocol CategoryColorModalDependency: Dependency {
  var selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream { get }
}

final class CategoryColorModalComponent: Component<CategoryColorModalDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CategoryColorModalBuildable: Buildable {
    func build(withListener listener: CategoryColorModalListener) -> CategoryColorModalRouting
}

final class CategoryColorModalBuilder: Builder<CategoryColorModalDependency>, CategoryColorModalBuildable {

    override init(dependency: CategoryColorModalDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CategoryColorModalListener) -> CategoryColorModalRouting {
        let component = CategoryColorModalComponent(dependency: dependency)
        let viewController = CategoryColorModalViewController()
        let interactor = CategoryColorModalInteractor(
          presenter: viewController,
          selectedFilterInProductMood: dependency.selectedFilterInProductMood
        )
        interactor.listener = listener
        return CategoryColorModalRouter(interactor: interactor, viewController: viewController)
    }
}
