//
//  GenderViewController.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import Util
import CommonUI

protocol GenderPresentableListener: AnyObject {
  func popGenderVC(with popType: PopType)
  func pushAgeVC()
  
  var selectedGenderType: BehaviorRelay<GenderType?> { get }
  func checkedGender(gender: GenderType)
}

final class GenderViewController: UIViewController, GenderPresentable, GenderViewControllable {
  
  weak var listener: GenderPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let titleSubtitleView: TitleSubtitleView = TitleSubtitleView()
  
  private let womanButton: CheckButton = CheckButton(title: "여성")
  private let manButton: CheckButton = CheckButton(title: "남성")
  private let noneButton: CheckButton = CheckButton(title: "선택하지 않음")
  
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
      listener?.popGenderVC(with: .Swipe)
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
    
    self.womanButton.tap()
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.checkedGender(gender: .Woman)
      }).disposed(by: disposeBag)
    
    self.manButton.tap()
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.checkedGender(gender: .Man)
      }).disposed(by: disposeBag)
    
    self.noneButton.tap()
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.checkedGender(gender: .None)
      }).disposed(by: disposeBag)
    
    self.nextButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.pushAgeVC()
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    self.listener?.selectedGenderType
      .compactMap{$0}
      .bind { [weak self] genderType in
        guard let self else { return }
        self.womanButton.changeIconImage(icon: genderType == .Woman ? .DecoImage.checkSec : .DecoImage.checkLightgray1)
        self.manButton.changeIconImage(icon: genderType == .Man ? .DecoImage.checkSec : .DecoImage.checkLightgray1)
        self.noneButton.changeIconImage(icon: genderType == .None ? .DecoImage.checkSec : .DecoImage.checkLightgray1)
        
        self.nextButton.isEnabled = true
      }.disposed(by: disposeBag)
  }
  
  // MARK: - GenderPresentable
  func set(nickname: String) {
    self.titleSubtitleView.setupTitleSubtitle(
      title: "\(nickname)님, 성별을 알려주실래요?",
      subTitle: "\(nickname)님의 취향을 파악하는데 도움이 될 것 같아요."
    )
  }
}
