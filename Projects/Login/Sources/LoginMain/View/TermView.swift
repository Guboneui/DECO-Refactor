//
//  TermView.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxGesture
import Util

class TermView: UIView {
  
  private let disposeBag = DisposeBag()
  
  private let containerView = UIView()
  
  private let startLabel = UILabel().then {
    $0.text = "DECO를 시작하게 되면 "
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 8)
    $0.textColor = .DecoColor.gray3
  }
  
  private let termLabel = UILabel().then {
    let attributedString = $0.makeUnderLineAttributedString(
      with: "이용약관",
      height: 12.0,
      font: .DecoFont.getFont(with: .NotoSans, type: .bold, size: 8),
      underLineColor: .DecoColor.gray3
    )
    $0.attributedText = attributedString
    $0.textColor = .DecoColor.gray3
  }
  
  private let andLabel = UILabel().then {
    $0.text = "과 "
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 8)
    $0.textColor = .DecoColor.gray3
  }
  
  private let privacyLabel = UILabel().then {
    let attributedString = $0.makeUnderLineAttributedString(
      with: "개인정보취급방침",
      height: 12.0,
      font: .DecoFont.getFont(with: .NotoSans, type: .bold, size: 8),
      underLineColor: .DecoColor.gray3
    )
    $0.attributedText = attributedString
    $0.textColor = .DecoColor.gray3
  }
  
  private let agreeLabel = UILabel().then {
    $0.text = "에 동의하게 됩니다."
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 8)
    $0.textColor = .DecoColor.gray3
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
    
    containerView.flex.direction(.row).justifyContent(.center).define { flex in
      flex.addItem(startLabel)
      flex.addItem(termLabel)
      flex.addItem(andLabel)
      flex.addItem(privacyLabel)
      flex.addItem(agreeLabel)
    }
  }
  
  private func setupLayouts() {
    containerView.pin.all()
    containerView.flex.layout(mode: .adjustHeight)
    self.pin.wrapContent(.vertically)
  }
  
  private func setupGestures() {
    termLabel.tap()
      .subscribe(onNext: { _ in
        SafariLoderImpl.loadSafari(with: DecoURL.termURL)
      }).disposed(by: disposeBag)
    
    privacyLabel.tap()
      .subscribe(onNext: { _ in
        SafariLoderImpl.loadSafari(with: DecoURL.privacyURL)
      }).disposed(by: disposeBag)
  }
}
