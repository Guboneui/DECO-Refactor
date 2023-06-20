//
//  AppSettingViewController.swift
//  Profile
//
//  Created by 구본의 on 2023/05/27.
//

import UIKit

import Util
import CommonUI

import RIBs
import RxSwift


public protocol AppSettingPresentableListener: AnyObject {
  func popAppSettingVC(with popType: PopType)
  func showLogoutPopup()
}

final class AppSettingViewController: UIViewController, AppSettingPresentable, AppSettingViewControllable {
  
  weak var listener: AppSettingPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "설정",
    showGuideLine: true
  )
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
  }
  
  private let scrollBoundsView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.lightBackground
  }
  
  private let alertSettingView: LinkWithImageView = LinkWithImageView(image: .DecoImage.bell, title: "알림 설정")
  private let appNoticeView: LinkWithImageView = LinkWithImageView(image: .DecoImage.bulb, title: "공지사항")
  private let sendOpinionView: LinkWithImageView = LinkWithImageView(image: .DecoImage.talk, title: "의견 보내기")
  private let termsOfServiceView: LinkWithImageView = LinkWithImageView(image: .DecoImage.info, title: "서비스 이용약관")
  private let privacyPolicyView: LinkWithImageView = LinkWithImageView(image: .DecoImage.paper, title: "개인 정보 처리 방침")
  private let openSourceLicenseView: LinkWithImageView = LinkWithImageView(image: .DecoImage.question, title: "오픈 소스 라이선스")
  private let logoutView: LinkWithImageView = LinkWithImageView(image: .DecoImage.login, title: "로그아웃")
  private let deactivateView: LinkWithImageView = LinkWithImageView(image: .DecoImage.bye, title: "탈퇴하기")
  
  private let bottomGuideLineView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.lightBackground
  }
  
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
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popAppSettingVC(with: .Swipe)
    }
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(scrollView)
    self.scrollBoundsView.addSubview(alertSettingView)
    self.scrollView.addSubview(scrollBoundsView)
    self.scrollBoundsView.addSubview(appNoticeView)
    self.scrollBoundsView.addSubview(sendOpinionView)
    self.scrollBoundsView.addSubview(termsOfServiceView)
    self.scrollBoundsView.addSubview(privacyPolicyView)
    self.scrollBoundsView.addSubview(openSourceLicenseView)
    self.scrollBoundsView.addSubview(logoutView)
    self.scrollBoundsView.addSubview(deactivateView)
    self.scrollBoundsView.addSubview(bottomGuideLineView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    scrollView.pin
      .below(of: navigationBar)
      .horizontally()
      .bottom()
    
    scrollBoundsView.pin
      .top()
      .horizontally()
    
    alertSettingView.pin
      .top()
      .horizontally()

    appNoticeView.pin
      .below(of: alertSettingView)
      .horizontally()

    sendOpinionView.pin
      .below(of: appNoticeView)
      .horizontally()
      .marginTop(10)

    termsOfServiceView.pin
      .below(of: sendOpinionView)
      .horizontally()

    privacyPolicyView.pin
      .below(of: termsOfServiceView)
      .horizontally()
      .marginTop(10)

    openSourceLicenseView.pin
      .below(of: privacyPolicyView)
      .horizontally()
    
    logoutView.pin
      .below(of: openSourceLicenseView)
      .horizontally()
      .marginTop(10)
    
    deactivateView.pin
      .below(of: logoutView)
      .horizontally()
    
    bottomGuideLineView.pin
      .below(of: deactivateView)
      .horizontally()
      .height(10)
      .bottom()

    scrollBoundsView.pin
      .wrapContent(.vertically)
    
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: scrollBoundsView.frame.maxY)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popAppSettingVC(with: .BackButton)
    }
    
    self.appNoticeView.tap()
      .bind { _ in
        SafariLoder.loadSafari(with: DecoURL.appNoriceURL)
      }.disposed(by: disposeBag)
    
    self.termsOfServiceView.tap()
      .bind { _ in
        SafariLoder.loadSafari(with: DecoURL.appServiceTermURL)
      }.disposed(by: disposeBag)
    
    self.privacyPolicyView.tap()
      .bind { _ in
        SafariLoder.loadSafari(with: DecoURL.privacyURL)
      }.disposed(by: disposeBag)
    
    self.logoutView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.showLogoutPopup()
      }.disposed(by: disposeBag)
  }
}
