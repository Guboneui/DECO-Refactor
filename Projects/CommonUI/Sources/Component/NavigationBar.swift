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
    $0.setImage(.DecoImage.arrowDarkgray2, for: .normal)
    $0.tintColor = .DecoColor.darkGray1
    $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let guideLineView = UIView().then {
    $0.backgroundColor = .DecoColor.lightGray1
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
    self.frame.size.height = 45
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.backgroundColor = .DecoColor.whiteColor
    self.titleLabel.text = navTitle
    
    self.addSubview(backButton)
    self.addSubview(titleLabel)
    
    if showGuideLine {
      self.addSubview(guideLineView)
    }
  }
  
  private func setupLayouts() {
    self.pin.horizontally()
    
    backButton.pin
      .vertically()
      .left()
      .size(48)
    
    titleLabel.pin.after(of: backButton, aligned: .center)
      .marginLeft(8)
      .sizeToFit()
    
    if showGuideLine {
      guideLineView.pin
        .bottom()
        .horizontally()
        .height(0.5)
    }
    
    self.pin.wrapContent(.vertically)
    
  }
  
  private func setupGestures() {
    backButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
  }
  
  @objc private func didTapButton() {
    didTapBackButton?()
  }
}
