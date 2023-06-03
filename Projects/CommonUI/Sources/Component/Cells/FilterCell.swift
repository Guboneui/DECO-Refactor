//
//  FilterCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/04.
//

import UIKit

public class FilterCell: UICollectionViewCell {
  
  public static let identifier = "FilterCell"
  
  private let textLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.sizeToFit()
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
  
  private func setupViews() {
    self.contentView.addSubview(textLabel)
    self.contentView.addSubview(selectedView)
    
    self.contentView.makeCornerRadius(radius: 14)
    
  }
  
  private func setupLayouts() {
    self.textLabel.pin
      .horizontally(12)
      .vCenter()
      .sizeToFit(.width)
    
    self.selectedView.pin.all()
    
    self.contentView.pin.wrapContent()
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: 30)
  }
  
  public func setupCellConfigure(
    text: String,
    isSelected: Bool
  ) {
    self.textLabel.text = text
    self.textLabel.font = .DecoFont.getFont(with: .Suit, type: isSelected ? .bold : .medium, size: 12)
    self.textLabel.textColor = isSelected ? .DecoColor.secondaryColor : .DecoColor.gray2
    self.contentView.makeBorder(width: 1.0, borderColor: isSelected ? .DecoColor.secondaryColor : .DecoColor.lightGray1)
    self.selectedView.backgroundColor = isSelected ? .DecoColor.lightSecondaryColor : .clear
  }
}





