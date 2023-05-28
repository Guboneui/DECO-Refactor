//
//  PhotoBookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs

protocol PhotoBookmarkDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PhotoBookmarkComponent: Component<PhotoBookmarkDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PhotoBookmarkBuildable: Buildable {
    func build(withListener listener: PhotoBookmarkListener) -> PhotoBookmarkRouting
}

final class PhotoBookmarkBuilder: Builder<PhotoBookmarkDependency>, PhotoBookmarkBuildable {

    override init(dependency: PhotoBookmarkDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PhotoBookmarkListener) -> PhotoBookmarkRouting {
        let component = PhotoBookmarkComponent(dependency: dependency)
        let viewController = PhotoBookmarkViewController()
        let interactor = PhotoBookmarkInteractor(presenter: viewController)
        interactor.listener = listener
        return PhotoBookmarkRouter(interactor: interactor, viewController: viewController)
    }
}
