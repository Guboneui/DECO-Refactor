//
//  ProductBookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs

protocol ProductBookmarkDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProductBookmarkComponent: Component<ProductBookmarkDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductBookmarkBuildable: Buildable {
    func build(withListener listener: ProductBookmarkListener) -> ProductBookmarkRouting
}

final class ProductBookmarkBuilder: Builder<ProductBookmarkDependency>, ProductBookmarkBuildable {

    override init(dependency: ProductBookmarkDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductBookmarkListener) -> ProductBookmarkRouting {
        let component = ProductBookmarkComponent(dependency: dependency)
        let viewController = ProductBookmarkViewController()
        let interactor = ProductBookmarkInteractor(presenter: viewController)
        interactor.listener = listener
        return ProductBookmarkRouter(interactor: interactor, viewController: viewController)
    }
}
