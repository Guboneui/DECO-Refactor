//
//  AppDelegate.swift
//  DECO
//
//  Created by 구본의 on 2023/04/20.
//  Copyright © 2023 Boni. All rights reserved.
//

import UIKit
import Login
import RIBs
import Util

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
	private var launchRouter: LaunchRouting?
	private var ribTreeViewer: RIBTreeViewer?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		
		let launchRouter = AppRootBuilder(dependency: AppComponent()).build(with: window)
		self.launchRouter = launchRouter
		self.launchRouter?.launch(from: window)
		
		ribTreeViewer = RIBTreeViewer(rootRouter: launchRouter)
		ribTreeViewer?.startObserveTree()
		
    return true
  }
}



