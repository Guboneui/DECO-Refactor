//
//  BrandProductUsageHeaderView.swift
//  Product
//
//  Created by 구본의 on 2023/05/23.
//

import UIKit

import RxSwift

class BrandProductUsageHeaderView: UIView {
  
  var didTapLinkButton: (()->(Void))?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let productUsageLabel: UILabel = UILabel().then {
    $0.text = "이 브랜드의 제품은 이렇게 활용했어요"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
  }
  
  private let linkedButton: UIButton = UIButton(type: .system).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.tintColor = .DecoColor.darkGray2
    $0.setImage(.DecoImage.arrowRight)
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
    self.addSubview(productUsageLabel)
    self.addSubview(linkedButton)
  }
  
  private func setupLayouts() {
    productUsageLabel.pin
      .topLeft()
      .marginLeft(24)
      .sizeToFit()
    
    linkedButton.pin
      .topRight()
      .marginRight(12)
      .size(18)
  
    self.pin
      .wrapContent(.vertically)
  }
  
  private func setupGestures() {
    self.linkedButton.rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] in
        guard let self else { return }
        self.didTapLinkButton?()
      }.disposed(by: disposeBag)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    self.pin.width(size.width)
    self.setupLayouts()
    return CGSize(width: UIScreen.main.bounds.width, height: self.frame.maxY+16)
  }
}

