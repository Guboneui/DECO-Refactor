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

class ProductCategoryImageCell: UICollectionViewCell {
  static let identifier = "ProductCategoryImageCell"
  
  private let imageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .orange
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.contentView.addSubview(imageView)
    
  }
  
  private func setupLayouts() {
    self.imageView.pin
      .all()
      .height(60)
    
    self.contentView.pin.wrapContent()
  }
  
  
}

