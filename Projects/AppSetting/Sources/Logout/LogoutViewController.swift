//
//  LogoutViewController.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/20.
//

import UIKit

import CommonUI

import RIBs
import RxSwift


protocol LogoutPresentableListener: AnyObject {
  func dismissLogoutPopup()
}

final class LogoutViewController: PopupViewController, LogoutPresentable, LogoutViewControllable {
  
  weak var listener: LogoutPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "로그아웃 하실래요?"
    $0.textColor = .DecoColor.darkGray1
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 14)
  }
  
  private let cancelButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("취소")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.tintColor = .DecoColor.successColor
  }
  
  private let logoutButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("로그아웃")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.setupLayouts()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    baseView.makeCornerRadius(radius: 12)
    baseView.addSubview(titleLabel)
    baseView.addSubview(cancelButton)
    baseView.addSubview(logoutButton)
  }
  
  private func setupLayouts() {
    titleLabel.pin
      .top()
      .horizontally(24)
      .height(60)
    
    cancelButton.pin
      .below(of: titleLabel)
      .left()
      .right(to: titleLabel.edge.hCenter)
      .height(60)
    
    logoutButton.pin
      .below(of: titleLabel)
      .after(of: cancelButton)
      .right()
      .height(60)
  }
  
  private func setupGestures() {
    bgView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.hideAnimation { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.dismissLogoutPopup()
        }
      }.disposed(by: disposeBag)
    
    cancelButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.hideAnimation { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.dismissLogoutPopup()
        }
      }.disposed(by: disposeBag)
  }
}
