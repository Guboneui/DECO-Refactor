//
//  NavigationBar.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/25.
//

import UIKit
import PinLayout
import FlexLayout
import Then

public class NavigationBar: UIView {
  

  // MARK: Property
  private var navTitle: String?
  private let showGuideLine: Bool
  
  public var didTapBackButton: (()->())?
  
  private let backButton = UIButton(type: .system).then {
    $0.setImage(CommonUIAsset.Image.arrowDarkgrey2.image, for: .normal)
    $0.tintColor = CommonUIAsset.Color.darkGray1.color
    $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
  
  private let titleLabel = UILabel().then {
    $0.font = CommonUIFontFamily.Suit.bold.font(size: 16)
    $0.textColor = CommonUIAsset.Color.darkGray2.color
  }
  
  private let guideLineView = UIView().then {
    $0.backgroundColor = CommonUIAsset.Color.lightGray1.color
  }
  
  
  public init(navTitle: String? = nil, showGuideLine: Bool) {
    self.navTitle = navTitle
    self.showGuideLine = showGuideLine
    super.init(frame: .zero)

    self.setupViews()
    self.setupGestures()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.backgroundColor = CommonUIAsset.Color.whiteColor.color
    
    self.addSubview(backButton)
    self.addSubview(titleLabel)
    
    if showGuideLine {
      self.addSubview(guideLineView)
    }
    
    self.titleLabel.text = navTitle
  }
  
  private func setupLayouts() {
    pin.height(48)
    
    backButton.pin
      .vertically()
      .left()
      .size(48)

    titleLabel.pin
      .left(to: backButton.edge.right)
      .marginLeft(8)
      .centerRight()
      .sizeToFit(.width)
    
    if showGuideLine {
      guideLineView.pin
        .horizontally()
        .bottom()
        .height(0.5)
    }
    
  }
  
  private func setupGestures() {
    backButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  @objc private func didTapButton() {
    didTapBackButton?()
  }
}
