//
//  DefaultTextCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/21.
//

import UIKit

public class DefaultTextCell: UICollectionViewCell {
  
  public static let identifier = "DefaultTextCell"
  
  private let textLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.darkGray1
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
  
  
  public func setupCellConfigure(
    text: String
  ) {
    self.textLabel.text = text
  }
}
