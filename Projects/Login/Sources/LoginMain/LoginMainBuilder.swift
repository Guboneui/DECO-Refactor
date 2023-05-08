//
//  LoginMainBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit
import Networking

public protocol LoginMainDependency: Dependency, LoginMainInteractorDependency {
}

final public class LoginMainComponent:
  Component<LoginMainDependency>,
  NickNameDependency
{
  var userControlRepository: UserControlRepositoryImpl { dependency.userControlRepository }
  var signUpInfoStream: MutableSignUpStream = UserSignUpStreamImpl()
}


// MARK: - Builder

public protocol LoginMainBuildable: Buildable {
  func build(withListener listener: LoginMainListener) -> LoginMainRouting
}

final public class LoginMainBuilder: Builder<LoginMainDependency>, LoginMainBuildable {
  
  override public init(dependency: LoginMainDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: LoginMainListener) -> LoginMainRouting {
    let component = LoginMainComponent(dependency: dependency)
    let viewController = LoginMainViewController()
    let nav = NavigationControllerable(root: viewController)
    nav.navigationController.navigationBar.isHidden = true
    
    let interactor = LoginMainInteractor(
      presenter: viewController,
      dependency: dependency,
      userSignUpInfoStream: component.signUpInfoStream
    )
    interactor.listener = listener
    
    let nicknameBuilder = NickNameBuilder(dependency: component)
    
    return LoginMainRouter(
      interactor: interactor,
      navigationController: nav,
      nicknameBuildable: nicknameBuilder
    )
  }
}
