//
//  ProductSailInfoView.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import UIKit
import Then
import PinLayout
import FlexLayout

class ProductSailInfoView: UIView {
  
  private let sailInfoLabel: UILabel = UILabel().then {
    $0.text = "구매 정보"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.gray2
    $0.sizeToFit()
  }
  
  private let sailInfoImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.info
  }
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
    self.backgroundColor = .DecoColor.whiteColor
  }
  
  private func setupViews() {
    self.addSubview(sailInfoLabel)
    self.addSubview(sailInfoImageView)
  }
  
  private func setupLayouts() {
    sailInfoLabel.pin
      .vCenter()
      .left()
      .sizeToFit(.width)
    
    sailInfoImageView.pin
      .after(of: sailInfoLabel, aligned: .center)
      .right()
      .size(16)
      .marginLeft(2)
    
    self.pin.wrapContent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
