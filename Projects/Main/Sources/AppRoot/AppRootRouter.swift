//
//  AppRootRouter.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import Login
import UIKit

protocol AppRootInteractable: Interactable, LoginMainListener {
	var router: AppRootRouting? { get set }
	var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
	
	private let window: UIWindow
	
	private let loginBuildable: LoginMainBuildable
	private var loginRouting: Routing?
	
	init(
		interactor: AppRootInteractable,
		viewController: AppRootViewControllable,
		loginBuildable: LoginMainBuildable,
		window: UIWindow
	) {
		self.loginBuildable = loginBuildable
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
}
