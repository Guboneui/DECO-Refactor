//
//  ColorFilterCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/04.
//

import UIKit

public class ColorFilterCell: UICollectionViewCell {
  
  public static let identifier = "ColorFilterCell"
  
  private let colorImageView: UIImageView = UIImageView().then {
    $0.makeCornerRadius(radius: 17)
  }
  
  private let textLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
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
    self.contentView.addSubview(colorImageView)
    self.contentView.addSubview(textLabel)
  }
  
  private func setupLayouts() {
    colorImageView.pin
      .top()
      .hCenter()
      .size(34)
    
    textLabel.pin
      .below(of: colorImageView)
      .horizontally()
      .bottom()
      .marginTop(8)
      .sizeToFit(.width)
    
    self.contentView.pin.wrapContent()
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: 60)
  }
  
  public func setupCellConfigure(
    text: String,
    image: UIImage,
    isSelected: Bool
  ) {
    self.textLabel.text = text
    self.textLabel.textColor = isSelected ? .DecoColor.secondaryColor : .DecoColor.gray4
    self.textLabel.font = .DecoFont.getFont(with: .Suit, type: isSelected ? .bold : .medium, size: 12)
    
    self.colorImageView.image = image
    self.colorImageView.makeBorder(
      width: isSelected ? 2.5 : 1.0,
      borderColor: isSelected ? .DecoColor.secondaryColor : .DecoColor.lightGray1
    )
  }
}
