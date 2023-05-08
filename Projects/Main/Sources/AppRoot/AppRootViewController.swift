//
//  AppRootViewController.swift
//  DECO
//
//  Created by 구본의 on 2023/05/02.
//  Copyright © 2023 boni. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import CommonUI
import Login

protocol AppRootPresentableListener: AnyObject {
	func moveToLogin()
}

final class AppRootViewController:
	UIViewController,
	AppRootPresentable,
	AppRootViewControllable,
	LoginMainViewControllable
{
	
	weak var listener: AppRootPresentableListener?
	
	private let logoImageView: UIImageView = UIImageView().then {
		$0.image = .DecoImage.logoWhite
		$0.contentMode = .scaleAspectFit
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
			guard let self else { return }
			self.listener?.moveToLogin()
			
		})
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.setupLayouts()
	}
	
	private func setupViews() {
		self.view.backgroundColor = .DecoColor.primaryColor
		
		self.view.addSubview(logoImageView)
	}
	
	private func setupLayouts() {
		logoImageView.pin
			.horizontally(100)
			.vCenter()
			.aspectRatio()
	}
}
