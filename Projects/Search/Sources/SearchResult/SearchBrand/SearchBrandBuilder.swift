//
//  SearchBrandBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchBrandDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchBrandComponent: Component<SearchBrandDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchBrandBuildable: Buildable {
    func build(withListener listener: SearchBrandListener) -> SearchBrandRouting
}

final class SearchBrandBuilder: Builder<SearchBrandDependency>, SearchBrandBuildable {

    override init(dependency: SearchBrandDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchBrandListener) -> SearchBrandRouting {
        let component = SearchBrandComponent(dependency: dependency)
        let viewController = SearchBrandViewController()
        let interactor = SearchBrandInteractor(presenter: viewController)
        interactor.listener = listener
        return SearchBrandRouter(interactor: interactor, viewController: viewController)
    }
}
