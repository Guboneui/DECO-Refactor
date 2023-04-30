//
//  DefaultButton.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/30.
//

import UIKit
import PinLayout

public class DefaultButton: UIButton {
  
  public override var isHighlighted: Bool {
    didSet {
      backgroundColor = isHighlighted ? CommonUIAsset.Color.primaryColor.color.withAlphaComponent(0.8) : CommonUIAsset.Color.primaryColor.color
    }
  }
  
  public override var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ? CommonUIAsset.Color.primaryColor.color : CommonUIAsset.Color.lightGray1.color
    }
  }
  
  public init(title: String? = nil) {
    super.init(frame: .zero)
    self.setTitle(title, for: .normal)
    self.setupDesign()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.frame.size.height = 45
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupDesign() {
    self.titleLabel?.font = CommonUIFontFamily.Suit.medium.font(size: 16)
    self.setTitleColor(CommonUIAsset.Color.darkGray2.color, for: .normal)
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 8
    self.backgroundColor = CommonUIAsset.Color.primaryColor.color
  }
}
