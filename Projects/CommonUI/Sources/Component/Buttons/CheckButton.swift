//
//  CheckButton.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit
import PinLayout

public class CheckButton: UIButton {
  
  private let iconImageView = UIImageView()
  private let label = UILabel()
  
  public override var isHighlighted: Bool {
    didSet { makeHighLightAnimation() }
  }
  
  public init(title: String = "", icon: UIImage = .DecoImage.checkLightgray1) {
    super.init(frame: .zero)
    self.setupDesign(title: title, icon: icon)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupDesign(title: String, icon: UIImage) {
    self.iconImageView.image = icon
    self.iconImageView.sizeToFit()
    self.addSubview(iconImageView)

    self.label.text = title
    self.label.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 16)
    self.label.textColor = .DecoColor.darkGray2
    self.label.textAlignment = .center
    self.addSubview(label)
  }
  
  private func setupLayouts() {
    
    let spacing: CGFloat = 8
    let iconSize: CGFloat = 34
    
    self.iconImageView.pin.vCenter().left().size(iconSize)
    self.label.pin.vCenter().after(of: iconImageView).marginHorizontal(spacing).sizeToFit()
    self.pin.wrapContent()
  }
  
  public func changeIconImage(icon: UIImage) {
    self.iconImageView.image = icon
  }
}
