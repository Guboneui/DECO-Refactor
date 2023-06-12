//
//  SearchUserBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchUserDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchUserComponent: Component<SearchUserDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchUserBuildable: Buildable {
    func build(withListener listener: SearchUserListener) -> SearchUserRouting
}

final class SearchUserBuilder: Builder<SearchUserDependency>, SearchUserBuildable {

    override init(dependency: SearchUserDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchUserListener) -> SearchUserRouting {
        let component = SearchUserComponent(dependency: dependency)
        let viewController = SearchUserViewController()
        let interactor = SearchUserInteractor(presenter: viewController)
        interactor.listener = listener
        return SearchUserRouter(interactor: interactor, viewController: viewController)
    }
}
