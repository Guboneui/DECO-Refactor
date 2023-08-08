//
//  FeedStickerView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/08/08.
//

import UIKit
import Then
import PinLayout

public class FeedStickerView: UIView {
  
  private let stickerTitle: String
  private let stickerType: StickerType
  private let stickerDirection: String
  private let isKnown: Bool
  
  public init(
    with title: String,
    type: StickerType,
    direction: String,
    isKnown: Bool
  ) {
    self.stickerTitle = title
    self.stickerType = type
    self.stickerDirection = direction
    self.isKnown = isKnown
    super.init(frame: .zero)
    self.setupViews()
  }
  
  private lazy var tagView: UIView = UIView().then {
    $0.makeCornerRadius(radius: 6)
    $0.backgroundColor = isKnown ? .DecoColor.primaryColor : .DecoColor.lightGray2
  }
  
  private let stickerView: UIView = UIView().then {
    $0.backgroundColor = .white.withAlphaComponent(0.9)
    $0.makeCornerRadius(radius: 8)
    $0.makeBorder(width: 0.75, borderColor: .DecoColor.lightGray1)
  }
  
  private lazy var stickerLabel: UILabel = UILabel().then {
    $0.text = stickerTitle
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 14)
  }
  
  private let stickerViewPadding: PEdgeInsets = PEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.backgroundColor = .clear
    
    self.addSubview(stickerView)
    stickerView.addSubview(stickerLabel)
    self.addSubview(tagView)
  }
  
  private func setupLayouts() {
    
    stickerLabel.pin
      .all()
      .sizeToFit()
    
    stickerView.pin
      .all()
      .wrapContent(padding: stickerViewPadding)

    self.pin.wrapContent(padding: 3)
    
    if let direction = StickerDirection(rawValue: stickerDirection) {
      switch direction {
      case .topLeft:
        tagView.pin
          .topLeft()
          .size(12)
      case .bottomLeft:
        tagView.pin
          .bottomLeft()
          .size(12)
      case .bottomRight:
        tagView.pin
          .bottomRight()
          .size(12)
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
