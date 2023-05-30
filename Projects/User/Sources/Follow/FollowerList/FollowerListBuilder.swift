//
//  FollowerListBuilder.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Networking

import RIBs

protocol FollowerListDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var followRepository: FollowRepository { get }
  var userProfileRepository: UserProfileRepository { get }
}

final class FollowerListComponent: Component<FollowerListDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FollowerListBuildable: Buildable {
  func build(withListener listener: FollowerListListener, targetUserID: Int) -> FollowerListRouting
}

final class FollowerListBuilder: Builder<FollowerListDependency>, FollowerListBuildable {
  
  override init(dependency: FollowerListDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: FollowerListListener,
    targetUserID: Int
  ) -> FollowerListRouting {
    let component = FollowerListComponent(dependency: dependency)
    let viewController = FollowerListViewController()
    let interactor = FollowerListInteractor(
      presenter: viewController,
      userManager: dependency.userManager,
      followRepository: dependency.followRepository,
      userProfileRepository: dependency.userProfileRepository,
      targetUserID: targetUserID
    )
    interactor.listener = listener
    return FollowerListRouter(interactor: interactor, viewController: viewController)
  }
}
