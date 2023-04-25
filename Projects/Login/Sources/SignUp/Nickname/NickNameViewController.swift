//
//  NickNameViewController.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import RxSwift
import UIKit
import RxGesture
import PinLayout
import CommonUI


protocol NickNamePresentableListener: AnyObject {
  
  func pop()
}

final class NickNameViewController: UIViewController, NickNamePresentable, NickNameViewControllable {
  
  weak var listener: NickNamePresentableListener?
  private let disposeBag = DisposeBag()
  
 
  private let navigationBar = NavigationBar(navTitle: "회원가입하기", showGuideLine: true)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupViews()
    setupGestures()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea.top)
      .horizontally()
  }
  
  private func setupGestures() {
    navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.pop()
    }
  }
}
