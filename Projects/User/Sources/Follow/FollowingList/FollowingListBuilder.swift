//
//  FollowingListBuilder.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Networking

import RIBs

protocol FollowingListDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var followRepository: FollowRepository { get }
}

final class FollowingListComponent: Component<FollowingListDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FollowingListBuildable: Buildable {
  func build(withListener listener: FollowingListListener, targetUserID: Int) -> FollowingListRouting
}

final class FollowingListBuilder: Builder<FollowingListDependency>, FollowingListBuildable {
  
  override init(dependency: FollowingListDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: FollowingListListener,
    targetUserID: Int
  ) -> FollowingListRouting {
    let component = FollowingListComponent(dependency: dependency)
    let viewController = FollowingListViewController()
    let interactor = FollowingListInteractor(
      presenter: viewController,
      userManager: dependency.userManager,
      followRepository: dependency.followRepository,
      targetUserID: targetUserID
    )
    interactor.listener = listener
    return FollowingListRouter(interactor: interactor, viewController: viewController)
  }
}
