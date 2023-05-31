//
//  TargetUserProfileBuilder.swift
//  User
//
//  Created by 구본의 on 2023/05/31.
//

import Entity
import Networking

import RIBs

protocol TargetUserProfileDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var userProfileRepository: UserProfileRepository { get }
  var followRepository: FollowRepository { get }
  
}

final class TargetUserProfileComponent: Component<TargetUserProfileDependency>, FollowDependency {
  var userManager: MutableUserManagerStream { dependency.userManager }
  
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TargetUserProfileBuildable: Buildable {
  func build(withListener listener: TargetUserProfileListener, targetUserInfo: UserDTO) -> TargetUserProfileRouting
}

final class TargetUserProfileBuilder: Builder<TargetUserProfileDependency>, TargetUserProfileBuildable {
  
  override init(dependency: TargetUserProfileDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: TargetUserProfileListener,
    targetUserInfo: UserDTO
  ) -> TargetUserProfileRouting {
    let component = TargetUserProfileComponent(dependency: dependency)
    let viewController = TargetUserProfileViewController()
    let interactor = TargetUserProfileInteractor(
      presenter: viewController,
      targetUserInfo: targetUserInfo,
      userManager: dependency.userManager,
      userProfileRepository: dependency.userProfileRepository,
      followRepository: dependency.followRepository
    )
    interactor.listener = listener
    
    let followBuildable = FollowBuilder(dependency: component)
    
    return TargetUserProfileRouter(
      interactor: interactor,
      viewController: viewController,
      followBuildable: followBuildable
    )
  }
}
