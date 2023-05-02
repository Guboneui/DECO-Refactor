//
//  AppComponent.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
	init() {
		super.init(dependency: EmptyComponent())
	}
}
