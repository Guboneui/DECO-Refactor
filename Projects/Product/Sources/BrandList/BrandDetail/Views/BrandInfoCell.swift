//
//  BrandInfoCell.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import UIKit

import Entity

import Then
import PinLayout
import FlexLayout

class BrandInfoCell: UITableViewCell {
  static let identifier: String = "BrandInfoCell"
  
  private let brandImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .DecoColor.lightBackground
    $0.makeCornerRadius(radius: 4)
  }
  
  private let brandNameLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    $0.numberOfLines = 0
  }
  
  private let brandDescriptionLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 10)
    $0.numberOfLines = 0
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
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
    self.contentView.addSubview(brandImageView)
    self.contentView.addSubview(brandNameLabel)
    self.contentView.addSubview(brandDescriptionLabel)
  }
  
  private func setupLayouts() {
    brandImageView.pin
      .topLeft()
      .marginLeft(16)
      .marginTop(20)
      .size(62)
    
    brandNameLabel.pin
      .after(of: brandImageView, aligned: .top)
      .right()
      .marginHorizontal(20)
      .marginTop(4)
      .sizeToFit(.width)
    
    brandDescriptionLabel.pin
      .below(of: brandNameLabel, aligned: .left)
      .right()
      .marginRight(20)
      .marginTop(8)
      .sizeToFit(.width)
    
    contentView.pin.wrapContent(.vertically)
  }
  
  public func setCellConfigure(brandInfo: BrandDTO) {
    self.brandImageView.loadImageWithThumbnail(
      thumbnail: .DecoImage.thumbnail,
      imageUrl: brandInfo.imageUrl
    )
    self.brandNameLabel.text = brandInfo.name
    self.brandDescriptionLabel.text = brandInfo.description
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    self.pin.width(size.width)
    self.setupLayouts()
    return CGSize(width: 200, height: contentView.frame.maxY + 40)
  }
}
