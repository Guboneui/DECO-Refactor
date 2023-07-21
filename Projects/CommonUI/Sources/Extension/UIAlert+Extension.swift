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

