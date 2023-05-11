//
//  MainBuilder.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs

public protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final public class MainBuilder: Builder<MainDependency>, MainBuildable {

    override public init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

  public func build(withListener listener: MainListener) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController)
        interactor.listener = listener
        return MainRouter(interactor: interactor, viewController: viewController)
    }
}
