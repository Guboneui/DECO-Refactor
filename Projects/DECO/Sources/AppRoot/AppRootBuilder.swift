//
//  AppRootBuilder.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//


import UIKit

import Main
import Login
import User
import Profile
import Networking

import RIBs

protocol AppRootDependency: Dependency {
	var userControlRepository: UserControlRepositoryImpl { get }
	var userManager: MutableUserManagerStream { get }
}

final class AppRootComponent:
	Component<AppRootDependency>,
	LoginMainDependency,
	MainDependency
{
	
	var userControlRepository: UserControlRepositoryImpl { dependency.userControlRepository }
	var userProfileRepository: UserProfileRepository { UserProfileRepositoryImpl() }
	var userManager: MutableUserManagerStream { dependency.userManager }
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
	//func build(withListener listener: AppRootListener) -> AppRootRouting
	func build(with window: UIWindow) -> LaunchRouting
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
	
	override init(dependency: AppRootDependency) {
		super.init(dependency: dependency)
	}
	
	func build(with window: UIWindow) -> LaunchRouting {
		let viewController = AppRootViewController()
		let component = AppRootComponent(dependency: dependency)
		let interactor = AppRootInteractor(
			presenter: viewController,
			userProfileRepository: component.userProfileRepository,
			userManager: component.userManager
		)
		
		let loginBuilder = LoginMainBuilder(dependency: component)
		let mainBuilder = MainBuilder(dependency: component)
		
		
		return AppRootRouter(
			interactor: interactor,
			viewController: viewController,
			loginBuildable: loginBuilder,
			mainBuildable: mainBuilder,
			window: window
		)
	}
}
