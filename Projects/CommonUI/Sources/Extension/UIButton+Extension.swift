//
//  UIButton+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit

extension UIButton {
  func makeHighLightAnimation() {
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: [.beginFromCurrentState, .transitionCrossDissolve, .curveEaseInOut],
      animations: {
        self.alpha = self.isHighlighted ? 0.8 : 1
      })
  }
}
