//
//  UIDevice+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/30.
//

import UIKit

public extension UIDevice {
  var hasNotch: Bool {
    let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    return bottom > 0
  }
}

