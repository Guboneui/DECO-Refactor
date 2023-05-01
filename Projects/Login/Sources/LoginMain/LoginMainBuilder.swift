//
//  LoginMainBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util

public protocol LoginMainDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class LoginMainComponent:
  Component<LoginMainDependency>,
  NickNameDependency,
  GenderDependency,
  AgeDependency {
  
}

// MARK: - Builder

protocol LoginMainBuildable: Buildable {
  func build() -> LaunchRouting
}

final public class LoginMainBuilder: Builder<LoginMainDependency>, LoginMainBuildable {
  
  override public init(dependency: LoginMainDependency) {
    super.init(dependency: dependency)
  }
  
  public func build() -> LaunchRouting {
    let component = LoginMainComponent(dependency: dependency)
    let viewController = LoginMainViewController()
    let nav = NavigationControllerable(root: viewController)
    nav.navigationController.navigationBar.isHidden = true
    
    let interactor = LoginMainInteractor(presenter: viewController)
    
    let nicknameBuilder = NickNameBuilder(dependency: component)
    let genderBuilder = GenderBuilder(dependency: component)
    let ageBuilder = AgeBuilder(dependency: component)
    
    return LoginMainRouter(
      interactor: interactor,
      viewController: nav,
      nicknameBuildable: nicknameBuilder,
      genderBuildable: genderBuilder,
      ageBuildable: ageBuilder
    )
  }
}
