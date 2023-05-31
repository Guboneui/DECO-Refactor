//
//  ProductCategoryDetailBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import RIBs

protocol ProductCategoryDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductCategoryDetailComponent: Component<ProductCategoryDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductCategoryDetailBuildable: Buildable {
    func build(withListener listener: ProductCategoryDetailListener) -> ProductCategoryDetailRouting
}

final class ProductCategoryDetailBuilder: Builder<ProductCategoryDetailDependency>, ProductCategoryDetailBuildable {

    override init(dependency: ProductCategoryDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductCategoryDetailListener) -> ProductCategoryDetailRouting {
        let component = ProductCategoryDetailComponent(dependency: dependency)
        let viewController = ProductCategoryDetailViewController()
        let interactor = ProductCategoryDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductCategoryDetailRouter(interactor: interactor, viewController: viewController)
    }
}
