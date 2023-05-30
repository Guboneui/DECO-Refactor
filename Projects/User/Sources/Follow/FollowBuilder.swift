//
//  FollowBuilder.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Networking

import RIBs

public protocol FollowDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
}

final class FollowComponent:
  Component<FollowDependency>,
  FollowerListDependency,
  FollowingListDependency
{
  var followRepository: FollowRepository { FollowRepositoryImpl() }
  var userManager: MutableUserManagerStream { dependency.userManager }
}

// MARK: - Builder

public protocol FollowBuildable: Buildable {
  func build(withListener listener: FollowListener, targetUserID: Int) -> FollowRouting
}

final public class FollowBuilder: Builder<FollowDependency>, FollowBuildable {
  
  override public init(dependency: FollowDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(
    withListener listener: FollowListener,
    targetUserID: Int
  ) -> FollowRouting {
    let component = FollowComponent(dependency: dependency)
    let viewController = FollowViewController()
    let interactor = FollowInteractor(
      presenter: viewController,
      userManager: dependency.userManager
    )
    interactor.listener = listener
    
    let followerListBuildable = FollowerListBuilder(dependency: component)
    let followingListBuildable = FollowingListBuilder(dependency: component)
    
    
    return FollowRouter(
      interactor: interactor,
      viewController: viewController,
      followerListBuildable: followerListBuildable,
      followingListBuildable: followingListBuildable,
      targetUserID: targetUserID
    )
  }
}
