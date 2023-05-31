//
//  ProductMoodDetailBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import RIBs

protocol ProductMoodDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductMoodDetailComponent: Component<ProductMoodDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductMoodDetailBuildable: Buildable {
    func build(withListener listener: ProductMoodDetailListener) -> ProductMoodDetailRouting
}

final class ProductMoodDetailBuilder: Builder<ProductMoodDetailDependency>, ProductMoodDetailBuildable {

    override init(dependency: ProductMoodDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductMoodDetailListener) -> ProductMoodDetailRouting {
        let component = ProductMoodDetailComponent(dependency: dependency)
        let viewController = ProductMoodDetailViewController()
        let interactor = ProductMoodDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductMoodDetailRouter(interactor: interactor, viewController: viewController)
    }
}
