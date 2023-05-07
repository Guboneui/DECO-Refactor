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
  var signUpInfoStream: MutableSignUpStream { get }
}

final class NickNameComponent:
  Component<NickNameDependency>,
  GenderDependency,
  NicknameInteractorDependency {
  
  var userControlRepository: UserControlRepositoryImpl { dependency.userControlRepository }
  var signUpInfoStream: MutableSignUpStream { dependency.signUpInfoStream }
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
      dependency: component,
      signUpInfo: component.signUpInfoStream
    )
    interactor.listener = listener
    
    let genderBuilder = GenderBuilder(dependency: component)
    
    return NickNameRouter(
      interactor: interactor,
      viewController: viewController,
      genderBuildable: genderBuilder
    )
  }
}
