//
//  UIView+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/24.
//  Copyright © 2023 Boni. All rights reserved.
//

import UIKit

public extension UIView {
  func makeCornerRadius(radius: CGFloat) {
    self.layer.masksToBounds = true
    self.layer.cornerRadius = radius
  }
  
  func makeBorder(width: CGFloat, borderColor: UIColor) {
    self.layer.masksToBounds = true
    self.layer.borderWidth = width
    self.layer.borderColor = borderColor.cgColor
  }
}
