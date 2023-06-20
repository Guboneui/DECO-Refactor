//
//  LogoutBuilder.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/20.
//

import RIBs

protocol LogoutDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class LogoutComponent: Component<LogoutDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LogoutBuildable: Buildable {
    func build(withListener listener: LogoutListener) -> LogoutRouting
}

final class LogoutBuilder: Builder<LogoutDependency>, LogoutBuildable {

    override init(dependency: LogoutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LogoutListener) -> LogoutRouting {
        let component = LogoutComponent(dependency: dependency)
        let viewController = LogoutViewController()
        let interactor = LogoutInteractor(presenter: viewController)
        interactor.listener = listener
        return LogoutRouter(interactor: interactor, viewController: viewController)
    }
}
