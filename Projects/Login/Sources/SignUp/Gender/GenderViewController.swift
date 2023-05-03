//
//  GenderViewController.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import UIKit
import Util
import CommonUI

protocol GenderPresentableListener: AnyObject {
  func popGenderVC(with popType: PopType)
  func pushAgeVC()
}

final class GenderViewController: UIViewController, GenderPresentable, GenderViewControllable {
  
  weak var listener: GenderPresentableListener?
  
  private let disposeBag = DisposeBag()
  
  private let navigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let titleSubtitleView = TitleSubtitleView(
    title: "00님, 성별을 알려주실래요?",
    subTitle: "00님의 취향을 파악하는데 도움이 될 것 같아요."
  )
  
  private let womanButton = CheckButton(title: "여성")
  private let manButton = CheckButton(title: "남성")
  private let noneButton = CheckButton(title: "선택하지 않음")
  
  private let nextButton = DefaultButton(title: "다음")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popGenderVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(titleSubtitleView)
    self.view.addSubview(womanButton)
    self.view.addSubview(manButton)
    self.view.addSubview(noneButton)
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
    
    womanButton.pin
      .below(of: titleSubtitleView)
      .left(30)
      .marginTop(32)
    
    manButton.pin
      .below(of: womanButton, aligned: .left)
      .marginTop(20)
    
    noneButton.pin
      .below(of: manButton, aligned: .left)
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
      self.listener?.popGenderVC(with: .BackButton)
    }
    
    self.nextButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.pushAgeVC()
      }.disposed(by: disposeBag)
  }
}
