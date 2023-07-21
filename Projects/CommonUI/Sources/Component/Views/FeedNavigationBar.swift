//
//  FeedNavigationBar.swift
//  CommonUI
//
//  Created by 구본의 on 2023/07/20.
//

import UIKit
import PinLayout
import FlexLayout
import Then

public class FeedNavigationBar: UIView {
  
  // MARK: Property
  
  public var didTapBackButtonAction: (()->())?
  public var didTapOptionButtonAction: (()->())?
  
  private let backButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.arrowWhite)
    $0.tintColor = .white
    $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
  
  private let optionButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.moreWhite)
    $0.tintColor = .white
  }
  
  public init() {
    super.init(frame: .zero)
    self.setupViews()
    self.setupGestures()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.frame.size.height = 48
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: 48)
  }
  
  private func setupViews() {
    self.backgroundColor = .black
    
    self.addSubview(backButton)
    self.addSubview(optionButton)
  }
  
  private func setupLayouts() {
    self.pin.horizontally()
    
    backButton.pin
      .vertically()
      .left()
      .size(48)
    
    optionButton.pin
      .vCenter()
      .right(16)
      .size(22)
    
    self.pin.wrapContent(.vertically)
    
  }
  
  private func setupGestures() {
    backButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    optionButton.addTarget(self, action: #selector(didTapOptionButton), for: .touchUpInside)
  }
  
  @objc private func didTapButton() {
    didTapBackButtonAction?()
  }
  
  @objc private func didTapOptionButton() {
    didTapOptionButtonAction?()
  }
  
}

