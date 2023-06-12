//
//  SearchPhotoBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchPhotoDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SearchPhotoComponent: Component<SearchPhotoDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchPhotoBuildable: Buildable {
    func build(withListener listener: SearchPhotoListener) -> SearchPhotoRouting
}

final class SearchPhotoBuilder: Builder<SearchPhotoDependency>, SearchPhotoBuildable {

    override init(dependency: SearchPhotoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchPhotoListener) -> SearchPhotoRouting {
        let component = SearchPhotoComponent(dependency: dependency)
        let viewController = SearchPhotoViewController()
        let interactor = SearchPhotoInteractor(presenter: viewController)
        interactor.listener = listener
        return SearchPhotoRouter(interactor: interactor, viewController: viewController)
    }
}
