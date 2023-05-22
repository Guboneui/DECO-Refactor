//
//  BrandProductUsageTableViewCell.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import UIKit

import CommonUI

class BrandProductUsageTableViewCell: UITableViewCell {
  
  static let identifier: String = "BrandProductUsageTableViewCell"
  
  private let productUsageLabel: UILabel = UILabel().then {
    $0.text = "이 브랜드의 제품은 이렇게 활용했어요"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
  }
  
  private let linkedButton: UIButton = UIButton(type: .system).then {
    $0.backgroundColor = .red
    $0.tintColor = .DecoColor.darkGray2
    $0.setImage(.DecoImage.arrowRight, for: .normal)
  }
  
  private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .blue
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    
  }
  
  private let collectionViewHeight: CGFloat = (UIScreen.main.bounds.width * 164.0) / 375.0
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupViews()
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.contentView.addSubview(productUsageLabel)
    self.contentView.addSubview(linkedButton)
    self.contentView.addSubview(collectionView)
  }
  
  private func setupLayouts() {
    productUsageLabel.pin
      .topLeft()
      .marginLeft(24)
      .sizeToFit()
    
    linkedButton.pin
      .topRight()
      .marginRight(12)
      .size(18)

    
    
    
    collectionView.pin
      .below(of: [productUsageLabel, linkedButton])
      .horizontally()
      .marginTop(16)
      .height(collectionViewHeight)
    
    contentView.pin
      .wrapContent(.vertically)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    self.pin.width(size.width)
    self.setupLayouts()
    return CGSize(width: UIScreen.main.bounds.width, height: contentView.frame.maxY + 40.0)
  }
}

extension BrandProductUsageTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
      return UICollectionViewCell()
    }
    
    return cell
  }
}

extension BrandProductUsageTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: collectionViewHeight, height: collectionViewHeight)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 8.0
  }
}
