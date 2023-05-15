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
    $0.textColor = .DecoColor.warningColor
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
    self.backgroundColor = .orange
    self.addSubview(label)
  }
  
  private func setupLayouts() {
    label.pin.all()
    self.pin.wrapContent()
  }
  
  func setCellConfigure(text: String) {
    self.label.text = text
  }
}
