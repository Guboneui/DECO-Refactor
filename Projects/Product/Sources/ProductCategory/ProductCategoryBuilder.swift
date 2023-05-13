//
//  ProductCategoryBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs

protocol ProductCategoryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductCategoryComponent: Component<ProductCategoryDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductCategoryBuildable: Buildable {
    func build(withListener listener: ProductCategoryListener) -> ProductCategoryRouting
}

final class ProductCategoryBuilder: Builder<ProductCategoryDependency>, ProductCategoryBuildable {

    override init(dependency: ProductCategoryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductCategoryListener) -> ProductCategoryRouting {
        let component = ProductCategoryComponent(dependency: dependency)
        let viewController = ProductCategoryViewController()
        let interactor = ProductCategoryInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductCategoryRouter(interactor: interactor, viewController: viewController)
    }
}
