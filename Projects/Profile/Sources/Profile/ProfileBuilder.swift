//
//  ProfileBuilder.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import Networking

import RIBs

public protocol ProfileDependency: Dependency
{
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class ProfileComponent:
  Component<ProfileDependency>,
  AppSettingDependency,
  ProfileEditDependency

{
  fileprivate var userProfileRepository: UserProfileRepository { UserProfileRepositoryImpl() }
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol ProfileBuildable: Buildable {
  func build(withListener listener: ProfileListener) -> ProfileRouting
}

final public class ProfileBuilder: Builder<ProfileDependency>, ProfileBuildable {
  
  override public init(dependency: ProfileDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: ProfileListener) -> ProfileRouting {
    let component = ProfileComponent(dependency: dependency)
    let viewController = ProfileViewController()

    let appSettingBuildable = AppSettingBuilder(dependency: component)
    let profileEditBuildable = ProfileEditBuilder(dependency: component)
    
    let interactor = ProfileInteractor(
      presenter: viewController,
      userProfileRepository: component.userProfileRepository
    )
    interactor.listener = listener
    return ProfileRouter(
      interactor: interactor,
      viewController: viewController,
      appSettingBuildable: appSettingBuildable,
      profileEditBuildable: profileEditBuildable
    )
  }
}
