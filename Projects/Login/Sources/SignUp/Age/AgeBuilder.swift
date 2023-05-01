//
//  AgeBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol AgeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AgeComponent: Component<AgeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AgeBuildable: Buildable {
    func build(withListener listener: AgeListener) -> AgeRouting
}

final class AgeBuilder: Builder<AgeDependency>, AgeBuildable {

    override init(dependency: AgeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AgeListener) -> AgeRouting {
        let component = AgeComponent(dependency: dependency)
        let viewController = AgeViewController()
        let interactor = AgeInteractor(presenter: viewController)
        interactor.listener = listener
        return AgeRouter(interactor: interactor, viewController: viewController)
    }
}
