//
//  UIAlert+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/07/22.
//

import UIKit

public extension UIAlertController {
  func addActions(_ actions: [UIAlertAction]) {
    actions.forEach { addAction($0) }
  }
}

public extension UIAlertAction {
  convenience init(
    title: String,
    titleColor: UIColor,
    style: UIAlertAction.Style,
    handler: ((UIAlertAction) -> Void)? = nil
  ) {
    self.init(title: title, style: style, handler: handler)
    self.setValue(titleColor, forKey: "titleTextColor")
  }
}
