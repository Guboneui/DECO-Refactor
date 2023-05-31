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
  var userProfileRepository: UserProfileRepository { get }
}

final class FollowingListComponent:
  Component<FollowingListDependency>,
  TargetUserProfileDependency
{
  var userManager: MutableUserManagerStream { dependency.userManager }
  var userProfileRepository: UserProfileRepository { dependency.userProfileRepository }
  var followRepository: FollowRepository { dependency.followRepository }
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
      userProfileRepository: dependency.userProfileRepository,
      targetUserID: targetUserID
    )
    interactor.listener = listener
    
    let targetUserProfileBuildable = TargetUserProfileBuilder(dependency: component)
    
    return FollowingListRouter(
      interactor: interactor,
      viewController: viewController,
      targetUserProfileBuildable: targetUserProfileBuildable
    )
  }
}
