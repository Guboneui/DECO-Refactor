//
//  AppComponent.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import Login
import User
import Networking

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
	var userControlRepository: UserControlRepositoryImpl
	var userManager: MutableUserManagerStream
	
	init() {
		self.userControlRepository = UserControlRepositoryImpl()
		self.userManager = UserManagerStreamImpl()
		super.init(dependency: EmptyComponent())
	}
}
