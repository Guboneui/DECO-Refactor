//
//  NickNameBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import Networking

protocol NickNameDependency: Dependency {
  var userControlRepository: UserControlRepositoryImpl { get }
}

final class NickNameComponent: Component<NickNameDependency>, NicknameInteractorDependency {
  var userControlRepository: UserControlRepositoryImpl { dependency.userControlRepository }
  
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
    let interactor = NickNameInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return NickNameRouter(interactor: interactor, viewController: viewController)
  }
}
