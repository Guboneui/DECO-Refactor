//
//  WithdrawBuilder.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/21.
//

import Networking

import RIBs

protocol WithdrawDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class WithdrawComponent: Component<WithdrawDependency> {
  
  fileprivate var withdrawRepository: WithdrawRepository = WithdrawRepositoryImpl()
}

// MARK: - Builder

protocol WithdrawBuildable: Buildable {
  func build(withListener listener: WithdrawListener) -> WithdrawRouting
}

final class WithdrawBuilder: Builder<WithdrawDependency>, WithdrawBuildable {
  
  override init(dependency: WithdrawDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: WithdrawListener) -> WithdrawRouting {
    let component = WithdrawComponent(dependency: dependency)
    let viewController = WithdrawViewController()
    let interactor = WithdrawInteractor(
      presenter: viewController,
      withdrawRepository: component.withdrawRepository
    )
    interactor.listener = listener
    return WithdrawRouter(interactor: interactor, viewController: viewController)
  }
}
