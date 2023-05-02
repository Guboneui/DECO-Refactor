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
	// TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
	func attachLogin()
}

protocol AppRootPresentable: Presentable {
	var listener: AppRootPresentableListener? { get set }
	// TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppRootListener: AnyObject {
	// TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
		// TODO: Implement business logic here.
	}
	
	override func willResignActive() {
		super.willResignActive()
		// TODO: Pause any business logic.
	}
	
	func moveToLogin() {
		router?.attachLogin()
	}
	
	func moveToHome() {
		// 홈 화면 이동 로직 구성하기
	}
}
