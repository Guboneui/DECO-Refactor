//
//  TouchAnimationView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/11.
//

import UIKit

open class TouchAnimationView: UIView {
  
  private let animationDuration: TimeInterval = 0.2
  private let animationDelay: TimeInterval = 0.0
  private let animationOptions: AnimationOptions = [
    .beginFromCurrentState,
    .transitionCrossDissolve,
    .curveEaseInOut
  ]
  private let originAlphaValue: CGFloat = 1.0
  private let highlightAlphaValue: CGFloat = 0.8
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    UIView.animate(
      withDuration: animationDuration,
      delay: animationDelay,
      options: animationOptions,
      animations: {
        self.alpha = self.highlightAlphaValue
      })
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    UIView.animate(
      withDuration: animationDuration,
      delay: animationDelay,
      options: animationOptions,
      animations: {
        self.alpha = self.originAlphaValue
      })
  }
}
