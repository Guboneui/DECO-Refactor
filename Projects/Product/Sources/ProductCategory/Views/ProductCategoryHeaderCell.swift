//
//  ProductCategoryHeaderCell.swift
//  Product
//
//  Created by 구본의 on 2023/05/15.
//

import UIKit

class ProductCategoryHeaderCell: UICollectionReusableView {
  static let identifier = "ProductCategoryHeaderCell"
  
  private let label: UILabel = UILabel().then {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
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
    self.addSubview(label)
  }
  
  private func setupLayouts() {
    label.pin
      .marginLeft(32)
      .all()
      
    
    self.pin.wrapContent(.vertically)
  }
  
  func setCellConfigure(text: String) {
    self.label.text = text
  }
}
