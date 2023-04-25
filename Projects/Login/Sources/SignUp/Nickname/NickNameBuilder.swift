//
//  NickNameBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs

protocol NickNameDependency: Dependency {
  
}

final class NickNameComponent: Component<NickNameDependency> {
  
}

// MARK: - Builder

protocol NickNameBuildable: Buildable {
  func build(withListener listener: NickNameListener) -> NickNameRouting
}

final class NickNameBuilder: Builder<NickNameDependency>, NickNameBuildable {
  
  override init(dependency: NickNameDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: NickNameListener) -> NickNameRouting {
    let component = NickNameComponent(dependency: dependency)
    let viewController = NickNameViewController()
    let interactor = NickNameInteractor(presenter: viewController)
    interactor.listener = listener
    return NickNameRouter(interactor: interactor, viewController: viewController)
  }
}
