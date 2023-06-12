//
//  SearchProductBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchProductDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchProductComponent: Component<SearchProductDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchProductBuildable: Buildable {
    func build(withListener listener: SearchProductListener) -> SearchProductRouting
}

final class SearchProductBuilder: Builder<SearchProductDependency>, SearchProductBuildable {

    override init(dependency: SearchProductDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchProductListener) -> SearchProductRouting {
        let component = SearchProductComponent(dependency: dependency)
        let viewController = SearchProductViewController()
        let interactor = SearchProductInteractor(presenter: viewController)
        interactor.listener = listener
        return SearchProductRouter(interactor: interactor, viewController: viewController)
    }
}
