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
  func popNicknameVC()
  func pushGenderVC()
}

final class NickNameViewController:
  UIViewController,
  NickNamePresentable,
  NickNameViewControllable
{
  
  weak var listener: NickNamePresentableListener?
  private let disposeBag = DisposeBag()
  
  
  private let navigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let titleSubtitleView = TitleSubtitleView(
    title: "반가워요! 닉네임을 정해주세요 :)",
    subTitle: "tip. 부르기 쉬운 한글 닉네임은 어때요?"
  )
  
  private let nicknameTextfield = UITextField().then {
    $0.placeholder = "닉네임을 작성해 주세요"
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 14)
    $0.textColor = .DecoColor.darkGray2
    $0.tintColor = .DecoColor.darkGray2
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 0.75
    $0.layer.borderColor = UIColor.DecoColor.lightGray2.cgColor
    $0.setLeftPaddingPoints(16)
    $0.setRightPaddingPoints(16)
  }
  
  private let warningLabel = UILabel().then {
    $0.text = "이미 사용중인 닉네임입니다"
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 10)
    $0.textColor = .DecoColor.warningColor
  }
  
  private let nextButton = DefaultButton(title: "다음")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(titleSubtitleView)
    self.view.addSubview(nicknameTextfield)
    self.view.addSubview(warningLabel)
    self.view.addSubview(nextButton)
  }
  
  private func setupLayouts() {
    
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    titleSubtitleView.pin
      .below(of: navigationBar)
      .horizontally()
      .marginTop(76)
    
    nicknameTextfield.pin
      .below(of: titleSubtitleView)
      .horizontally()
      .height(48)
      .margin(32, 35, 0, 30) // top left bottom right
    
    warningLabel.pin
      .below(of: nicknameTextfield, aligned: .left)
      .height(12)
      .marginLeft(3)
      .marginTop(12)
      .sizeToFit()
    
    nextButton.pin
      .bottom(view.pin.safeArea)
      .horizontally()
      .marginHorizontal(32)
      .marginBottom(UIDevice.current.hasNotch ? 34 : 43)
  }
  
  private func setupGestures() {
    navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popNicknameVC()
    }
    
    nextButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.pushGenderVC()
      }.disposed(by: disposeBag)
  }
}
