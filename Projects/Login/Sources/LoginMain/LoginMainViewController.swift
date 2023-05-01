//
//  LoginMainViewController.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import RxSwift
import RxGesture
import UIKit
import Then
import PinLayout
import CommonUI
import FlexLayout
import Util
import Hero

protocol LoginMainPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
  
  func pushNicknameVC(by loginType: LoginType)
}

final class LoginMainViewController:
  UIViewController,
  LoginMainPresentable,
  LoginMainViewControllable {
  
  weak var listener: LoginMainPresentableListener?
  private let disposeBag = DisposeBag()
  
  private let logoImageView = UIImageView().then {
    $0.image = .DecoImage.logoYellow
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "온라인 감성 문구 편집샵"
    $0.textColor = .DecoColor.darkGray1
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 18)
  }
  
  private let termView = TermView()
  private let socialLoginView = LoginView()
  
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  private func setupViews() {
    self.view.backgroundColor = .DecoColor.whiteColor
    
    self.view.addSubview(logoImageView)
    self.view.addSubview(titleLabel)
    self.view.addSubview(termView)
    self.view.addSubview(socialLoginView)
  }
  
  // MARK: - Method
  
  private func setupLayouts() {
    
    logoImageView.pin
      .top(127)
      .left(53)
      .height(40)
      .aspectRatio()
    
    titleLabel.pin
      .below(of: logoImageView, aligned: .left)
      .marginTop(20)
      .sizeToFit()
    
    termView.pin
      .bottom(view.pin.safeArea.bottom)
      .horizontally()
      .marginBottom(51)
    
    socialLoginView.pin
      .above(of: termView)
      .height(224)
      .horizontally()
      .marginBottom(76)
  }
  
  private func setupGestures() {
    kakaoLoginView.rx.tapGesture()
      .when(.recognized)
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] _ in
        guard let self else { return }
        print("🔊[DEBUG]: 카카오 클릭")
        self.listener?.pushNicknameVC()
        
      }.disposed(by: disposeBag)
    
    
    termLabel.rx.tapGesture()
      .when(.recognized)
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .subscribe(onNext: { _ in
        SafariLoderImpl.loadSafari(with: DecoURL.termURL)
      }).disposed(by: disposeBag)
    
    privacyLabel.rx.tapGesture()
      .when(.recognized)
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .subscribe(onNext: { _ in
        SafariLoderImpl.loadSafari(with: DecoURL.privacyURL)
      }).disposed(by: disposeBag)
  }
}
