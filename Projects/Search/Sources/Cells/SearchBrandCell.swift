//
//  SearchBrandCell.swift
//  Search
//
//  Created by 구본의 on 2023/06/13.
//

import UIKit

import Util

import Then
import PinLayout

public class SearchBrandCell: UICollectionViewCell {
  
  public static let identifier = "SearchBrandCell"

  private let brandImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .DecoColor.lightBackground
    $0.makeCornerRadius(radius: 4)
  }
  
  private let brandNameLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    self.brandImageView.image = nil
    self.brandNameLabel.text = nil
  }
  
  private func setupViews() {
    self.contentView.addSubview(brandImageView)
    self.contentView.addSubview(brandNameLabel)
  }
  
  private func setupLayouts() {
    
    brandImageView.pin
      .vertically()
      .left(20)
      .size(50)
    
    brandNameLabel.pin
      .after(of: brandImageView, aligned: .center)
      .right(10)
      .marginLeft(16)
      .sizeToFit(.width)
  }
  
  
  public func setupCellConfigure(
    brandImageURL: String,
    brandName: String
  ) {
    self.brandImageView.loadImageWithThumbnail(
      thumbnail: .DecoImage.thumbnail,
      imageUrl: brandImageURL
    )
    self.brandNameLabel.text = brandName
  }
}

