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
      backgroundColor = isHighlighted ? .DecoColor.primaryColor.withAlphaComponent(0.8) : .DecoColor.primaryColor
    }
  }
  
  public override var isEnabled: Bool {
    didSet {
      backgroundColor = isEnabled ? .DecoColor.primaryColor : .DecoColor.lightGray1
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
    self.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 16)
    self.setTitleColor(.DecoColor.darkGray2, for: .normal)
    self.layer.masksToBounds = true
    self.layer.cornerRadius = 8
    self.backgroundColor = .DecoColor.primaryColor
  }
}
