//
//  AppRootBuilder.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import UIKit
import Login
import Home
import Networking

protocol AppRootDependency: Dependency {
	var userControlRepository: UserControlRepositoryImpl { get }
}

final class AppRootComponent:
	Component<AppRootDependency>,
	LoginMainDependency,
	HomeDependency
{
	var userControlRepository: UserControlRepositoryImpl { dependency.userControlRepository }
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
		let interactor = AppRootInteractor(presenter: viewController)
		
		let loginBuilder = LoginMainBuilder(dependency: component)
		let homeBuilder = HomeBuilder(dependency: component)
		
		
		return AppRootRouter(
			interactor: interactor,
			viewController: viewController,
			loginBuildable: loginBuilder,
			homeBuildable: homeBuilder,
			window: window
		)
	}
}
