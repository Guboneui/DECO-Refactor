//
//  FeedTextStickerView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/08/10.
//

import UIKit
import Then
import PinLayout

public class FeedTextStickerView: UIView {
  
  private let stickerText: String
  private let stickerAlignment: String
  private let textColorID: Int
  private let backgroundColorID: Int
  
  public init(
    with text: String,
    alignment: String,
    textColorID: Int,
    backgroundColorID: Int
  ) {
    self.stickerText = text
    self.stickerAlignment = alignment
    self.textColorID = textColorID
    self.backgroundColorID = backgroundColorID
    super.init(frame: .zero)
    self.setupViews()
  }
  
  private lazy var textLabel: UILabel = UILabel().then {
    $0.text = stickerText
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 14)
    $0.textColor = FeedTextColor().getFeedTextColor(colorID: textColorID).color
    $0.numberOfLines = 0
    switch stickerAlignment {
      case "LEFT": $0.textAlignment = .left
      case "RIGHT": $0.textAlignment = .right
      case "CENTER":  $0.textAlignment = .center
      default: $0.textAlignment = .left
    }
  }
  
  private let stickerViewPadding: PEdgeInsets = PEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.makeCornerRadius(radius: 8)
    self.backgroundColor = FeedBackgroundColor().getFeedBackgroundColor(colorID: backgroundColorID).backgroundColor
    
    self.addSubview(textLabel)
  }
  
  private func setupLayouts() {
    textLabel.pin
      .all()
      .sizeToFit()
    
    self.pin.wrapContent(padding: stickerViewPadding)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
