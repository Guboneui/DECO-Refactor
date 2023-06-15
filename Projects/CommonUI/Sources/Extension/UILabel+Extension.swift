//
//  UILabel+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/24.
//  Copyright © 2023 Boni. All rights reserved.
//

import UIKit

public extension UILabel {
  func makeUnderLineAttributedString(
    with text: String,
    height: CGFloat,
    font: UIFont,
    underLineColor: UIColor
  ) -> NSAttributedString {
    let style = NSMutableParagraphStyle()
    style.maximumLineHeight = height
    style.minimumLineHeight = height
    
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .font: font,
      .baselineOffset: (12 - font.lineHeight) / 4,
      .underlineStyle: NSUnderlineStyle.single.rawValue,
      .underlineColor: underLineColor
    ]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    return attributedString
  }
  
  func makeEmptySearchResultNoticeText() {
    let headerText = "앗! 다른 "
    let mainText = "단어"
    let trailingText = "를 검색해 주세요."

    let headerTextAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.DecoFont.getFont(with: .NotoSans, type: .medium, size: 12),
      .foregroundColor: UIColor.DecoColor.darkGray2
    ]

    let mainTextAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.DecoFont.getFont(with: .NotoSans, type: .bold, size: 12),
      .foregroundColor: UIColor.DecoColor.darkGray2
    ]

    let trailingTextAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.DecoFont.getFont(with: .NotoSans, type: .medium, size: 12),
      .foregroundColor: UIColor.DecoColor.darkGray2
    ]

    let noticeText = [headerText, mainText, trailingText].joined(separator: "")
    let attributedString = NSMutableAttributedString(string: noticeText)

    let headerTextRange = attributedString.mutableString.range(of: headerText)
    let mainTextRange = attributedString.mutableString.range(of: mainText)
    let trailingTextRange = attributedString.mutableString.range(of: trailingText)

    attributedString.addAttributes(headerTextAttributes, range: headerTextRange)
    attributedString.addAttributes(mainTextAttributes, range: mainTextRange)
    attributedString.addAttributes(trailingTextAttributes, range: trailingTextRange)
    
    self.attributedText = attributedString
  }
}
