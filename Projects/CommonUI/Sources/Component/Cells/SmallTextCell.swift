//
//  SmallTextCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/23.
//

import UIKit

public class SmallTextCell: UICollectionViewCell {
  
  public static let identifier = "SmallTextCell"
  
  private let textLabel: UILabel = UILabel().then {
    $0.text = "test"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
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
    self.contentView.addSubview(textLabel)
  }
  
  private func setupLayouts() {
    self.textLabel.pin
      .horizontally()
      .vCenter()
      .sizeToFit(.width)
    
    self.contentView.pin.wrapContent()
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: 18)
  }
  
  public func setupCellConfigure(
    text: String,
    isSelected: Bool
  ) {
    self.textLabel.text = text
    self.textLabel.textColor = isSelected ? .DecoColor.darkGray2 : .DecoColor.lightGray2
  }
}



