//
//  BrandListCell.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import UIKit

import Then
import PinLayout
import CommonUI

class BrandListCell: UICollectionViewCell {
  static let identifier: String = "BrandListCell"
  
  private let label: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .bold, size: 16)
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.label.text = nil
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.backgroundColor = .DecoColor.whiteColor
    self.contentView.addSubview(label)
  }
  
  private func setupLayouts() {
    label.pin
      .all()
      .marginLeft(32)
  }
  
  func setCellConfigure(text: String) {
    self.label.text = text
  }
}
