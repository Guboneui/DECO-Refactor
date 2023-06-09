//
//  FilterCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/04.
//

import UIKit

public class FilterCell: UICollectionViewCell {
  
  public static let identifier = "FilterCell"
  public static let horizontalMargin: CGFloat = 12
  
  private let textLabelBaseFont: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  
  private let textLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.sizeToFit()
  }
  private let selectedView: UIView = UIView().then {
    $0.backgroundColor = .blue
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
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    self.textLabel.text = nil
  }
  
  private func setupViews() {
    self.contentView.addSubview(selectedView)
    self.selectedView.addSubview(textLabel)

    self.selectedView.makeCornerRadius(radius: 14)
    
  }
  
  private func setupLayouts() {
    self.selectedView.pin
      .left()
      .vertically()
      .width(getTextLabelWidth())
    
    self.textLabel.pin
      .horizontally(FilterCell.horizontalMargin)
      .vCenter()
      .sizeToFit(.width)
  }
  
  private func getTextLabelWidth() -> CGFloat {
    let labelWidth: CGFloat = (textLabel.text ?? "").size(withAttributes: [NSAttributedString.Key.font:textLabelBaseFont]).width
    return labelWidth + (2*FilterCell.horizontalMargin)
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
    self.selectedView.makeBorder(width: 1.0, borderColor: isSelected ? .DecoColor.secondaryColor : .DecoColor.lightGray1)
    self.selectedView.backgroundColor = isSelected ? .DecoColor.lightSecondaryColor : .clear
  }
}





