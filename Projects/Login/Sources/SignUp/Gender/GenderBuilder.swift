//
//  GenderBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol GenderDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class GenderComponent: Component<GenderDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol GenderBuildable: Buildable {
  func build(withListener listener: GenderListener) -> GenderRouting
}

final class GenderBuilder: Builder<GenderDependency>, GenderBuildable {
  
  override init(dependency: GenderDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: GenderListener) -> GenderRouting {
    let component = GenderComponent(dependency: dependency)
    let viewController = GenderViewController()
    let interactor = GenderInteractor(presenter: viewController)
    interactor.listener = listener
    return GenderRouter(interactor: interactor, viewController: viewController)
  }
}
