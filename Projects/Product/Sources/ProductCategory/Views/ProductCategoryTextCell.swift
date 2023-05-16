//
//  ProductCategoryTextCell.swift
//  Product
//
//  Created by 구본의 on 2023/05/15.
//

import UIKit
import Then
import PinLayout
import CommonUI

class ProductCategoryTextCell: UICollectionViewCell {
  static let identifier = "ProductCategoryTextCell"
  
  private let label: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.darkGray2
    $0.sizeToFit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.backgroundColor = .DecoColor.whiteColor
    self.contentView.addSubview(label)
  }
  
  private func setupLayouts() {
    label.pin.all()
    self.contentView.pin.wrapContent()
  }
  
  func setCellConfigure(text: String) {
    self.label.text = text
  }
}
