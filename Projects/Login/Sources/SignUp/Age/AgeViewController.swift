//
//  AgeViewController.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import UIKit
import CommonUI

protocol AgePresentableListener: AnyObject {
  func popAgeVC()
  func pushMoodVC()
}

final class AgeViewController: UIViewController, AgePresentable, AgeViewControllable {
  
  weak var listener: AgePresentableListener?
  private let disposeBag = DisposeBag()
  
  private let navigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let titleSubtitleView = TitleSubtitleView(
    title: "00님, 만 14세 이상이신가요?",
    subTitle: "앱 정책 상 만 14세 미만은 이용이 불가해요."
  )
  
  private let yesButton = CheckButton(title: "네")
  private let noButton = CheckButton(title: "아니오")
  
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
      self.listener?.popAgeVC()
    }
    
    self.nextButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.pushMoodVC()
      }.disposed(by: disposeBag)
  }
}
