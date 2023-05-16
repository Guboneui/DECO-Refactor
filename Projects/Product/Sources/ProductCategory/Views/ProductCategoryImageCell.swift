//
//  ProductCategoryImageCell.swift
//  Product
//
//  Created by 구본의 on 2023/05/15.
//

import UIKit
import Then
import PinLayout
import CommonUI
import Util

class ProductCategoryImageCell: UICollectionViewCell {
  static let identifier = "ProductCategoryImageCell"
  
  private let imageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }

  private let alphaView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor.withAlphaComponent(0.3)
  }

  private let label: UILabel = UILabel().then {
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textAlignment = .center
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
    self.contentView.addSubview(imageView)
    self.imageView.addSubview(alphaView)
    self.alphaView.addSubview(label)

    self.contentView.makeCornerRadius(radius: 23)
    self.contentView.makeBorder(width: 0.5, borderColor: .DecoColor.lightGray1)
  }

  private func setupLayouts() {
    self.imageView.pin.all()
    self.alphaView.pin.all()
    self.label.pin.all()
  }
  
  func setCellConfigure(imageURL: String?, text: String) {
    self.label.text = text
    if let imageURL {
      self.imageView.loadImage(imageUrl: imageURL)
    }
  }
}

