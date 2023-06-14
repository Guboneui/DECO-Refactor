//
//  ProductInfoView.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import UIKit

import Entity

import Then
import PinLayout
import FlexLayout

class ProductInfoView: UIView {
  
  private let brandNameLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    $0.textColor = .DecoColor.darkGray2
    
  }
  private let productNameLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 12)
    $0.textColor = .DecoColor.darkGray2
  }
  private let productPriceLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.gray2
  }
  
  private let bookmarkButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.saveThick)
    $0.tintColor = .DecoColor.gray4
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
    self.flex.direction(.column).justifyContent(.start).padding(0, 24).define { flex in
      flex.addItem().direction(.row).define { flex in
        flex.addItem(brandNameLabel).shrink(1).grow(1)
        flex.addItem(bookmarkButton).size(25)
      }
      flex.addItem(productNameLabel)
      flex.addItem(productPriceLabel).marginTop(8)
    }
  }
  
  public func setProductInfo(productInfo: ProductDetailDTO) {
    brandNameLabel.text = productInfo.brandName
    brandNameLabel.flex.markDirty()
    
    productNameLabel.text = productInfo.product.name
    productNameLabel.flex.markDirty()
    
    self.bookmarkButton.setImage(productInfo.scrap ? .DecoImage.saveFullWhite : .DecoImage.saveThick)
    self.bookmarkButton.tintColor = productInfo.scrap ? .DecoColor.secondaryColor : .DecoColor.gray4
    
    let price = productInfo.product.price
    if price != 0 {
      self.productPriceLabel.text = price.numberFormatter() + "원"
      self.productPriceLabel.flex.markDirty()
    }
    
    setupLayouts()
  }
  
  private func setupLayouts() {
    self.flex.layout(mode: .adjustHeight)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
