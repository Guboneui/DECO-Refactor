//
//  AgeViewController.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import CommonUI
import Util

protocol AgePresentableListener: AnyObject {
  func popAgeVC(with popType: PopType)
  func pushMoodVC()
  
  var selectedAgeType: BehaviorRelay<AgeType?> { get }
  func checkedAge(ageType: AgeType)
}

final class AgeViewController:
  UIViewController,
  AgePresentable,
  AgeViewControllable
{
  
  // MARK: - Property
  
  weak var listener: AgePresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  // MARK: - UIComponent
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let titleSubtitleView: TitleSubtitleView = TitleSubtitleView()
  
  private let yesButton: CheckButton = CheckButton(title: "네")
  private let noButton: CheckButton = CheckButton(title: "아니오")
  
  private let nextButton: DefaultButton = DefaultButton(title: "다음").then {
    $0.isEnabled = false
  }
  
  // MARK: - LifeCycle
  
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
      listener?.popAgeVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  
  // MARK: - Private Method
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(titleSubtitleView)
    self.view.addSubview(yesButton)
    self.view.addSubview(noButton)
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
    
    yesButton.pin
      .below(of: titleSubtitleView)
      .left(30)
      .marginTop(32)
    
    noButton.pin
      .below(of: yesButton, aligned: .left)
      .marginTop(20)
    
    nextButton.pin
      .bottom(view.pin.safeArea)
      .horizontally()
      .marginHorizontal(32)
      .marginBottom(UIDevice.current.hasNotch ? 34 : 43)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popAgeVC(with: .BackButton)
    }
    
    self.yesButton.tap()
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.checkedAge(ageType: .Upper)
      }).disposed(by: disposeBag)
    
    self.noButton.tap()
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.checkedAge(ageType: .Lower)
      }).disposed(by: disposeBag)
    
    self.nextButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.pushMoodVC()
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    self.listener?.selectedAgeType
      .compactMap{$0}
      .bind { [weak self] ageType in
        guard let self else { return }
        self.yesButton.changeIconImage(icon: ageType == .Upper ? .DecoImage.checkSec : .DecoImage.checkLightgray1)
        self.noButton.changeIconImage(icon: ageType == .Lower ? .DecoImage.checkSec : .DecoImage.checkLightgray1)
        self.nextButton.isEnabled = true
      }.disposed(by: disposeBag)
  }
  
  // MARK: - AgePresentable
  func set(nickname: String) {
    self.titleSubtitleView.setupTitleSubtitle(
      title: "\(nickname)님, 만 14세 이상이신가요?",
      subTitle: "앱 정책 상 만 14세 미만은 이용이 불가해요."
    )
  }
}
