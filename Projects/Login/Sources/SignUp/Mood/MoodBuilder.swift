//
//  MoodBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol MoodDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MoodComponent: Component<MoodDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MoodBuildable: Buildable {
    func build(withListener listener: MoodListener) -> MoodRouting
}

final class MoodBuilder: Builder<MoodDependency>, MoodBuildable {

    override init(dependency: MoodDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MoodListener) -> MoodRouting {
        let component = MoodComponent(dependency: dependency)
        let viewController = MoodViewController()
        let interactor = MoodInteractor(presenter: viewController)
        interactor.listener = listener
        return MoodRouter(interactor: interactor, viewController: viewController)
    }
}
