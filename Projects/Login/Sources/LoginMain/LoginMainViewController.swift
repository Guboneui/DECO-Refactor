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
  
  func pushNicknameVC()
}

final class LoginMainViewController:
  UIViewController,
  LoginMainPresentable,
  LoginMainViewControllable {
  
  weak var listener: LoginMainPresentableListener?
  private let disposeBag = DisposeBag()
  
  private let logoImageView = UIImageView().then {
    $0.image = CommonUIAsset.Image.logoYellow.image
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "온라인 감성 문구 편집샵"
    $0.textColor = CommonUIAsset.Color.darkGray1.color
    $0.font = CommonUIFontFamily.NotoSansKR.medium.font(size: 18)
  }
  
  private let infoContainer = UIView()
  
  private let startLabel = UILabel().then {
    $0.text = "DECO를 시작하게 되면 "
    $0.font = CommonUIFontFamily.NotoSansKR.medium.font(size: 8)
    $0.textColor = CommonUIAsset.Color.gray3.color
  }
  
  private let termLabel = UILabel().then {
    let attributedString = $0.makeUnderLineAttributedString(
      with: "이용약관",
      height: 12.0,
      font: CommonUIFontFamily.NotoSansKR.bold.font(size: 8),
      underLineColor: CommonUIAsset.Color.gray3.color
    )
    $0.attributedText = attributedString
    $0.textColor = CommonUIAsset.Color.gray3.color
  }
  
  private let andLabel = UILabel().then {
    $0.text = "과 "
    $0.font = CommonUIFontFamily.NotoSansKR.medium.font(size: 8)
    $0.textColor = CommonUIAsset.Color.gray3.color
  }
  
  private let privacyLabel = UILabel().then {
    let attributedString = $0.makeUnderLineAttributedString(
      with: "개인정보취급방침",
      height: 12.0,
      font: CommonUIFontFamily.NotoSansKR.bold.font(size: 8),
      underLineColor: CommonUIAsset.Color.gray3.color
    )
    $0.attributedText = attributedString
    $0.textColor = CommonUIAsset.Color.gray3.color
  }
  
  private let agreeLabel = UILabel().then {
    $0.text = "에 동의하게 됩니다."
    $0.font = CommonUIFontFamily.NotoSansKR.medium.font(size: 8)
    $0.textColor = CommonUIAsset.Color.gray3.color
  }
  
  private let loginContainer = UIView()
  
  private let kakaoLoginView = UIView().then {
    $0.backgroundColor = CommonUIAsset.Color.kakao.color
    $0.makeCornerRadius(radius: 8.0)
  }
  
  private let kakaoLogoImageView = UIImageView().then {
    $0.image = CommonUIAsset.Image.kakaoLogo.image
  }
  
  private let kakaoLoginLabel = UILabel().then {
    $0.text = "카카오로 시작하기"
    $0.textColor = CommonUIAsset.Color.blackColor.color.withAlphaComponent(0.85)
    $0.font = CommonUIFontFamily.Suit.bold.font(size: 16)
  }
  
  private let naverLoginView = UIView().then {
    $0.backgroundColor = CommonUIAsset.Color.naver.color
    $0.makeCornerRadius(radius: 8.0)
  }
  
  private let naverLogoImageView = UIImageView().then {
    $0.image = CommonUIAsset.Image.naverLogo.image
  }
  
  private let naverLoginLabel = UILabel().then {
    $0.text = "네이버로 시작하기"
    $0.textColor = CommonUIAsset.Color.whiteColor.color
    $0.font = CommonUIFontFamily.Suit.bold.font(size: 16)
  }
  
  
  
  private let googleLoginView = UIView().then {
    $0.backgroundColor = CommonUIAsset.Color.whiteColor.color
    $0.makeCornerRadius(radius: 8.0)
    $0.makeBorder(width: 1.0, borderColor: CommonUIAsset.Color.lightGray2.color)
  }
  
  private let googleLogoImageView = UIImageView().then {
    $0.image = CommonUIAsset.Image.googleLogo.image
  }
  
  private let googleLoginLabel = UILabel().then {
    $0.text = "구글로 시작하기"
    $0.textColor = CommonUIAsset.Color.gray3.color
    $0.font = CommonUIFontFamily.Suit.bold.font(size: 16)
  }
  
  
  private let appleLoginView = UIView().then {
    $0.backgroundColor = CommonUIAsset.Color.blackColor.color
    $0.makeCornerRadius(radius: 8.0)
    
  }
  
  private let appleLogoImageView = UIImageView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let appleLoginLabel = UILabel().then {
    $0.text = "애플로 시작하기"
    $0.textColor = CommonUIAsset.Color.whiteColor.color
    $0.font = CommonUIFontFamily.Suit.bold.font(size: 16)
  }
  
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
    self.view.backgroundColor = CommonUIAsset.Color.whiteColor.color
    
    self.view.addSubview(logoImageView)
    self.view.addSubview(titleLabel)
    self.view.addSubview(infoContainer)
    self.view.addSubview(loginContainer)
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
    
    infoContainer.pin
      .bottom(view.pin.safeArea.bottom)
      .hCenter()
      .width(241)
      .height(12)
      .marginBottom(51)
    
    infoContainer.flex.direction(.row).define { flex in
      flex.addItem(startLabel)
      flex.addItem(termLabel)
      flex.addItem(andLabel)
      flex.addItem(privacyLabel)
      flex.addItem(agreeLabel)
    }
    
    infoContainer.flex.layout(mode: .adjustWidth)
    
    loginContainer.pin
      .above(of: infoContainer, aligned: .center)
      .marginBottom(76)
      .height(200)
      .width(270)
    
    loginContainer.flex.direction(.column).define { flex in
      flex.addItem(kakaoLoginView).height(47).width(270)
      kakaoLoginView.flex.direction(.row)
        .alignItems(.center)
        .define { kakaoView in
          kakaoView.addItem(kakaoLogoImageView).marginLeft(56).size(16)
          kakaoView.addItem(kakaoLoginLabel).marginLeft(20)
        }
      
      flex.addItem(naverLoginView).height(47).width(270).marginTop(12)
      naverLoginView.flex.direction(.row)
        .alignItems(.center)
        .define { naverView in
          naverView.addItem(naverLogoImageView).marginLeft(56).size(16)
          naverView.addItem(naverLoginLabel).marginLeft(20)
        }
      
      flex.addItem(googleLoginView).height(47).width(270).marginTop(12)
      googleLoginView.flex.direction(.row)
        .alignItems(.center)
        .define { googleView in
          googleView.addItem(googleLogoImageView).marginLeft(56).size(16)
          googleView.addItem(googleLoginLabel).marginLeft(20)
        }
      
      flex.addItem(appleLoginView).height(47).width(270).marginTop(12)
      appleLoginView.flex.direction(.row)
        .alignItems(.center)
        .define { appleView in
          appleView.addItem(appleLogoImageView).marginLeft(56).size(16)
          appleView.addItem(appleLoginLabel).marginLeft(20)
        }
      
    }
    
    loginContainer.flex.layout(mode: .adjustWidth)
    
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
