//
//  ImageCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit
import Then
import PinLayout

import Util

public enum ImageCellType {
  case DefaultType
  case SelectedType
}

public class ImageCell: UICollectionViewCell {
  
  public static let identifier = "ImageCell"
  
  private let mainImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .DecoColor.lightBackground
  }
  
  private let selectedView = UIView().then {
    $0.backgroundColor = .DecoColor.secondaryColor
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.contentView.addSubview(mainImageView)
  }
  
  private func setupLayouts() {
    self.mainImageView.pin.all()
    self.contentView.pin.wrapContent()
  }
  
  public func setupCellData(
    type: ImageCellType,
    image: UIImage? = nil,
    isSelected: Bool = false,
    imageURL: String = ""
  ) {
    switch type {
    case .DefaultType:
      self.mainImageView.loadImage(imageUrl: imageURL)
    case .SelectedType:
      self.contentView.addSubview(selectedView)
      self.selectedView.pin.all()
      self.selectedView.alpha = isSelected ? 0.2 : 0.0
      
      if let image {
        self.mainImageView.image = image
      }
    }
  }
}


