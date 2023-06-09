//
//  AppSettingBuilder.swift
//  Profile
//
//  Created by 구본의 on 2023/05/27.
//

import RIBs

public protocol AppSettingDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class AppSettingComponent:
  Component<AppSettingDependency>,
  LogoutDependency,
  WithdrawDependency
{
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol AppSettingBuildable: Buildable {
  func build(withListener listener: AppSettingListener) -> AppSettingRouting
}

final public class AppSettingBuilder: Builder<AppSettingDependency>, AppSettingBuildable {
  
  public override init(dependency: AppSettingDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: AppSettingListener) -> AppSettingRouting {
    let component = AppSettingComponent(dependency: dependency)
    let viewController = AppSettingViewController()
    let interactor = AppSettingInteractor(presenter: viewController)
    interactor.listener = listener
    
    let logoutBuilder = LogoutBuilder(dependency: component)
    let withdrawBuilder = WithdrawBuilder(dependency: component)
    
    return AppSettingRouter(
      interactor: interactor,
      viewController: viewController,
      logoutBuildable: logoutBuilder,
      withdrawBuildable: withdrawBuilder
    )
  }
}
