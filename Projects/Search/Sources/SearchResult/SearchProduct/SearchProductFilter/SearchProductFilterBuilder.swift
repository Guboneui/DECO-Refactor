//
//  SearchProductFilterBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/18.
//

import RIBs

protocol SearchProductFilterDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchProductFilterComponent: Component<SearchProductFilterDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchProductFilterBuildable: Buildable {
    func build(withListener listener: SearchProductFilterListener) -> SearchProductFilterRouting
}

final class SearchProductFilterBuilder: Builder<SearchProductFilterDependency>, SearchProductFilterBuildable {

    override init(dependency: SearchProductFilterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchProductFilterListener) -> SearchProductFilterRouting {
        let component = SearchProductFilterComponent(dependency: dependency)
        let viewController = SearchProductFilterViewController()
        let interactor = SearchProductFilterInteractor(presenter: viewController)
        interactor.listener = listener
        return SearchProductFilterRouter(interactor: interactor, viewController: viewController)
    }
}
