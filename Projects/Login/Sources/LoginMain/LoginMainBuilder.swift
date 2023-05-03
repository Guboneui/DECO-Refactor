//
//  LoginMainBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit

public protocol LoginMainDependency: Dependency {
}

final public class LoginMainComponent:
  Component<LoginMainDependency>,
  NickNameDependency,
  GenderDependency,
  AgeDependency,
  MoodDependency
{
}

// MARK: - Builder

public protocol LoginMainBuildable: Buildable {
  func build() -> LoginMainRouting
}

final public class LoginMainBuilder: Builder<LoginMainDependency>, LoginMainBuildable {
  
  
  override public init(dependency: LoginMainDependency) {
    super.init(dependency: dependency)
  }
  
  public func build() -> LoginMainRouting {
    let component = LoginMainComponent(dependency: dependency)
    let viewController = LoginMainViewController()
    let nav = NavigationControllerable(root: viewController)
    nav.navigationController.navigationBar.isHidden = true
    
    let interactor = LoginMainInteractor(presenter: viewController)
    
    let nicknameBuilder = NickNameBuilder(dependency: component)
    let genderBuilder = GenderBuilder(dependency: component)
    let ageBuilder = AgeBuilder(dependency: component)
    let moodBuilder = MoodBuilder(dependency: component)
    
    return LoginMainRouter(
      interactor: interactor,
      navigationController: nav,
      nicknameBuildable: nicknameBuilder,
      genderBuildable: genderBuilder,
      ageBuildable: ageBuilder,
      moodBuildable: moodBuilder
    )
  }
  
}
