//
//  LoginView.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift
import RxGesture

class LoginView: UIView {
  
  private let disposeBag = DisposeBag()
  
  var kakaoLoginAction: (()->())?
  var naverLoginAction: (()->())?
  var googleLoginAction: (()->())?
  var appleLoginAction: (()->())?
  
  private let containerView = UIView()
  
  private let kakaoLoginView = UIView().then {
    $0.backgroundColor = .DecoColor.kakaoColor
    $0.makeCornerRadius(radius: 8.0)
  }
  
  private let kakaoLogoImageView = UIImageView().then {
    $0.image = .DecoImage.kakaoLogo
  }
  
  private let kakaoLoginLabel = UILabel().then {
    $0.text = "카카오로 시작하기"
    $0.textColor = .DecoColor.blackColor.withAlphaComponent(0.85)
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
  }
  
  private let naverLoginView = UIView().then {
    $0.backgroundColor = .DecoColor.naverColor
    $0.makeCornerRadius(radius: 8.0)
  }
  
  private let naverLogoImageView = UIImageView().then {
    $0.image = .DecoImage.naverLogo
  }
  
  private let naverLoginLabel = UILabel().then {
    $0.text = "네이버로 시작하기"
    $0.textColor = .DecoColor.whiteColor
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
  }
  
  private let googleLoginView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadius(radius: 8.0)
    $0.makeBorder(width: 1.0, borderColor: .DecoColor.lightGray2)
  }
  
  private let googleLogoImageView = UIImageView().then {
    $0.image = .DecoImage.googleLogo
  }
  
  private let googleLoginLabel = UILabel().then {
    $0.text = "구글로 시작하기"
    $0.textColor = .DecoColor.gray3
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
  }
  
  
  private let appleLoginView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor
    $0.makeCornerRadius(radius: 8.0)
    
  }
  
  private let appleLogoImageView = UIImageView().then {
    $0.image = .DecoImage.appleLogo
  }
  
  private let appleLoginLabel = UILabel().then {
    $0.text = "애플로 시작하기"
    $0.textColor = .DecoColor.whiteColor
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    self.setupGestures()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(containerView)
    
    containerView.flex.direction(.column).alignItems(.center).define { flex in
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
  }
  
  private func setupLayouts() {
    containerView.pin.all()
    containerView.flex.layout(mode: .adjustHeight)
    self.pin.wrapContent(.vertically)
  }
  
  private func setupGestures() {
    kakaoLoginView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.kakaoLoginAction?()
      }.disposed(by: disposeBag)
    
    naverLoginView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.naverLoginAction?()
      }.disposed(by: disposeBag)
    
    googleLoginView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.googleLoginAction?()
      }.disposed(by: disposeBag)
    
    appleLoginView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.appleLoginAction?()
      }.disposed(by: disposeBag)
  }
}
