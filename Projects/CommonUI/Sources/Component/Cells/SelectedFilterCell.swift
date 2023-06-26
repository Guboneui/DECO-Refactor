//
//  SelectedFilterCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/04.
//

import UIKit
import SnapKit

public class SelectedFilterCell: UICollectionViewCell {
  
  public static let identifier = "SelectedFilterCell"
  private let horizontalMargin: CGFloat = 10
  private let imageSize: CGFloat = 11
  private let itemSpacing: CGFloat = 2
  
  private let textLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.sizeToFit()
  }
  
  private let imageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let selectedView: UIView = UIView()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    self.textLabel.text = nil
  }
  
  private func setupViews() {
    self.contentView.addSubview(selectedView)
    self.contentView.addSubview(textLabel)
    self.contentView.addSubview(imageView)
    self.contentView.makeCornerRadius(radius: 14)
  }
  
  private func setupLayouts() {
    selectedView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    textLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(horizontalMargin)
      make.centerY.equalToSuperview()
    }
    
    imageView.snp.makeConstraints { make in
      make.leading.equalTo(textLabel.snp.trailing).offset(itemSpacing)
      make.trailing.equalToSuperview().inset(horizontalMargin)
      make.centerY.equalToSuperview()
      make.size.equalTo(imageSize)
    }
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: 30)
  }
  
  public func setupCellConfigure(
    text: String,
    isSelected: Bool
  ) {
    textLabel.text = text
    textLabel.font = .DecoFont.getFont(with: .Suit, type: isSelected ? .bold : .medium, size: 12)
    textLabel.textColor = isSelected ? .DecoColor.secondaryColor : .DecoColor.gray2
    contentView.makeBorder(width: 1.0, borderColor: isSelected ? .DecoColor.secondaryColor : .DecoColor.lightGray1)
    selectedView.backgroundColor = isSelected ? .DecoColor.lightSecondaryColor : .clear
    imageView.image = isSelected ? .DecoImage.closeSec : .DecoImage.resetDarkgray2
    
    setupLayouts()
  }
}
