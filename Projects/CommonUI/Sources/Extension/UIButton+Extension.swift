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
  
  public func setTitle(_ title: String?) {
    self.setTitle(title, for: .normal)
  }
  
  public func setTitleColor(_ color: UIColor?) {
    self.setTitleColor(color, for: .normal)
  }
  
  public func setImage(_ image: UIImage?) {
    self.setImage(image, for: .normal)
  }
}
