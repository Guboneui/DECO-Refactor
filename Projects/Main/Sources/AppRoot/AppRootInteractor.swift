//
//  AppRootInteractor.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import RxSwift


protocol AppRootRouting: ViewableRouting {
	func attachLogin()
	func attachHome()
}

protocol AppRootPresentable: Presentable {
	var listener: AppRootPresentableListener? { get set }
}

protocol AppRootListener: AnyObject {
	
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener {
	
	weak var router: AppRootRouting?
	weak var listener: AppRootListener?
	
	
	override init(presenter: AppRootPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
	
	func moveToLogin() {
		router?.attachLogin()
	}
	
	func moveToMainRIB() {
		router?.attachHome()
	}
}
