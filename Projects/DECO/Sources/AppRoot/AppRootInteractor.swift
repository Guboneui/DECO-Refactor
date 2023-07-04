//
//  AppRootInteractor.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import User
import Profile
import Networking

import RIBs
import RxSwift

protocol AppRootRouting: ViewableRouting {
	func attachLogin()
	func attachMain()
}

protocol AppRootPresentable: Presentable {
	var listener: AppRootPresentableListener? { get set }
}

protocol AppRootListener: AnyObject {
	
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener {
	
	weak var router: AppRootRouting?
	weak var listener: AppRootListener?
	
	private let userProfileRepository: UserProfileRepository
	private let userManager: MutableUserManagerStream
	
	init(
		presenter: AppRootPresentable,
		userProfileRepository: UserProfileRepository,
		userManager: MutableUserManagerStream
	) {
		self.userProfileRepository = userProfileRepository
		self.userManager = userManager
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		self.fetchUserProfile()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
	
	func moveToLogin() {
		router?.attachLogin()
	}
	
	func moveToMain() {
		router?.attachMain()
	}
	
	func moveToMainRIB() {
		router?.attachMain()
	}
	
	private func fetchUserProfile() {
		Task.detached { [weak self] in
			guard let self else { return }
			if let userInfo = await self.userProfileRepository.userProfile(id: 72, userID: 72) {
				self.userManager.updateUserInfo(
					with: UserManagerModel(
						nickname: userInfo.nickname,
						profileUrl: userInfo.profileUrl,
						backgroundUrl: userInfo.backgroundUrl,
						profileDescription: userInfo.profileDescription,
						profileName: userInfo.profileName,
						followCount: userInfo.followCount,
						followingCount: userInfo.followingCount,
						boardCount: userInfo.boardCount,
						userId: userInfo.userId,
						followStatus: userInfo.followStatus
					)
				)
				await MainActor.run {
					self.router?.attachMain()
				}
			}
		}
	}
}
