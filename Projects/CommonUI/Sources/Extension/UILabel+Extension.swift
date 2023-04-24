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
}
