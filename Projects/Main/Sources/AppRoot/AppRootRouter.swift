//
//  AppRootRouter.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import Login
import Home
import UIKit

protocol AppRootInteractable: Interactable, LoginMainListener, HomeListener {
	var router: AppRootRouting? { get set }
	var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
	
	private let window: UIWindow
	
	private let loginBuildable: LoginMainBuildable
	private var loginRouting: Routing?
	
	private let homeBuildable: HomeBuildable
	private var homeRouting: Routing?
	
	init(
		interactor: AppRootInteractable,
		viewController: AppRootViewControllable,
		loginBuildable: LoginMainBuildable,
		homeBuildable: HomeBuildable,
		window: UIWindow
	) {
		self.loginBuildable = loginBuildable
		self.homeBuildable = homeBuildable
		self.window = window
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachLogin() {
		if loginRouting != nil { return }
		let router = loginBuildable.build(withListener: interactor)
		window.rootViewController = router.viewControllable.uiviewController
		window.makeKeyAndVisible()
		attachChild(router)
		loginRouting = router
	}
	
	private func detachLogin() {
		if loginRouting != nil {
			detachChild(loginRouting!)
			loginRouting = nil
		}
	}
	
	func attachHome() {
		self.detachLogin()
		if homeRouting != nil { return }
		let router = homeBuildable.build(withListener: interactor)
		window.rootViewController = router.viewControllable.uiviewController
		window.makeKeyAndVisible()
		attachChild(router)
		homeRouting = router
		
	}
}
