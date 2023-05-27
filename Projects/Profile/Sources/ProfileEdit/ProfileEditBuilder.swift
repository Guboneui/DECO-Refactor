//
//  ProfileEditBuilder.swift
//  Profile
//
//  Created by 구본의 on 2023/05/28.
//

import User

import RIBs

protocol ProfileEditDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
}

final class ProfileEditComponent: Component<ProfileEditDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileEditBuildable: Buildable {
    func build(withListener listener: ProfileEditListener) -> ProfileEditRouting
}

final class ProfileEditBuilder: Builder<ProfileEditDependency>, ProfileEditBuildable {

    override init(dependency: ProfileEditDependency) {
        super.init(dependency: dependency)
    }

  func build(withListener listener: ProfileEditListener) -> ProfileEditRouting {
    let component = ProfileEditComponent(dependency: dependency)
    let viewController = ProfileEditViewController()
    let interactor = ProfileEditInteractor(
      presenter: viewController,
      userManager: dependency.userManager
    )
    interactor.listener = listener
    return ProfileEditRouter(interactor: interactor, viewController: viewController)
  }
}
