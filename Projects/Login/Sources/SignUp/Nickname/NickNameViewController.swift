//
//  NickNameViewController.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import RxGesture
import PinLayout
import CommonUI
import Util

protocol NickNamePresentableListener: AnyObject {
  func popNicknameVC(with popType: PopType)
  func pushGenderVC()
  
  var isEnableNickname: PublishSubject<Bool> { get }
  func checkNickname(nickName: String)
}

final class NickNameViewController:
  UIViewController,
  NickNamePresentable,
  NickNameViewControllable
{
  
  weak var listener: NickNamePresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let titleSubtitleView: TitleSubtitleView = TitleSubtitleView(
    title: "반가워요! 닉네임을 정해주세요 :)",
    subTitle: "tip. 부르기 쉬운 한글 닉네임은 어때요?"
  )
  
  private let nicknameTextfield: UITextField = UITextField().then {
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
  
  private let warningLabel: UILabel = UILabel().then {
    $0.text = "이미 사용중인 닉네임입니다"
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 10)
    $0.textColor = .DecoColor.warningColor
    $0.isHidden = true
  }
  
  private let nextButton: DefaultButton = DefaultButton(title: "다음").then {
    $0.isEnabled = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBindings()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popNicknameVC(with: .Swipe)
    }
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
      self.listener?.popNicknameVC(with: .BackButton)
    }
    
    nextButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        // 여기에서 닉네임도 함께 보내야 함.
        self.listener?.pushGenderVC()
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    nicknameTextfield.rx.text
      .compactMap{$0}
      .filter{!$0.trimmingCharacters(in: .whitespaces).isEmpty}
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.checkNickname(nickName: $0)
      }).disposed(by: disposeBag)
    
    listener?.isEnableNickname
      .asDriver(onErrorJustReturn: false)
      .drive { [weak self] isEnable in
        guard let self else { return }
        self.nextButton.isEnabled = isEnable
        self.warningLabel.isHidden = isEnable
      }.disposed(by: disposeBag)
  }
}
