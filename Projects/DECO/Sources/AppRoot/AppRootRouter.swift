//
//  AppRootRouter.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import Login
import Main
import UIKit
import Util

protocol AppRootInteractable: Interactable, LoginMainListener, MainListener {
	var router: AppRootRouting? { get set }
	var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
	
	private let window: UIWindow
	
	private let loginBuildable: LoginMainBuildable
	private var loginRouting: Routing?
	
	private let mainBuildable: MainBuildable
	private var mainRouting: Routing?
	
	init(
		interactor: AppRootInteractable,
		viewController: AppRootViewControllable,
		loginBuildable: LoginMainBuildable,
		mainBuildable: MainBuildable,
		window: UIWindow
	) {
		self.loginBuildable = loginBuildable
		self.mainBuildable = mainBuildable
		self.window = window
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachLogin() {
		if loginRouting != nil { return }
		let router = loginBuildable.build(withListener: interactor)
		window.rootViewController = router.viewControllable.uiviewController
		window.makeKeyAndVisible()
		loginRouting = router
		attachChild(router)
	}
	
	private func detachLogin() {
		if loginRouting != nil {
			loginRouting = nil
			detachChild(loginRouting!)
		}
	}
	
	func attachMain() {
		self.detachLogin()
		if mainRouting != nil { return }
		let router = mainBuildable.build(withListener: interactor)
		let navigation: NavigationControllerable = NavigationControllerable(root: router.viewControllable)
		navigation.navigationController.navigationBar.isHidden = true
		window.rootViewController = navigation.uiviewController
		window.makeKeyAndVisible()
		mainRouting = router
		attachChild(router)
	}
}

