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
import Networking

protocol LoginMainPresentableListener: AnyObject {
  func pushNicknameVC(by loginType: LoginType)
}

final public class LoginMainViewController:
  UIViewController,
  LoginMainPresentable,
  LoginMainViewControllable
{
  
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
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()     
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
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
    socialLoginView.kakaoLoginAction = { [weak self] in
      guard let self else { return }
      self.listener?.pushNicknameVC(by: .KAKAO)
    }
    
    socialLoginView.naverLoginAction = { [weak self] in
      guard let self else { return }
      self.listener?.pushNicknameVC(by: .NAVER)
    }
    
    socialLoginView.googleLoginAction = { [weak self] in
      guard let self else { return }
      self.listener?.pushNicknameVC(by: .GOOGLE)
    }
    
    socialLoginView.appleLoginAction = { [weak self] in
      guard let self else { return }
      self.listener?.pushNicknameVC(by: .APPLE)
    }
  }
}
