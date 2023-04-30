//
//  DecoFont.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit

public extension UIFont {
  struct DecoFont {
    
    public enum FontName {
      case NotoSans
      case Suit
    }
    
    public enum FontType {
      case thin
      case light
      case regular
      case medium
      case bold
    }
    
    public static func getFont(with name: FontName, type: FontType, size: CGFloat) -> UIFont {
      switch name {
      case .NotoSans:
        switch type {
        case .thin: return CommonUIFontFamily.NotoSansKR.thin.font(size: size)
        case .light: return CommonUIFontFamily.NotoSansKR.light.font(size: size)
        case .regular: return CommonUIFontFamily.NotoSansKR.regular.font(size: size)
        case .medium: return CommonUIFontFamily.NotoSansKR.medium.font(size: size)
        case .bold: return CommonUIFontFamily.NotoSansKR.bold.font(size: size)
        }
      case .Suit:
        switch type {
        case .thin: return CommonUIFontFamily.Suit.thin.font(size: size)
        case .light: return CommonUIFontFamily.Suit.light.font(size: size)
        case .regular: return CommonUIFontFamily.Suit.regular.font(size: size)
        case .medium: return CommonUIFontFamily.Suit.medium.font(size: size)
        case .bold: return CommonUIFontFamily.Suit.bold.font(size: size)
        }
      }
    }
  }
}
