//
//  UITextField+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/26.
//

import UIKit

public extension UITextField {
  
  func setLeftPaddingPoints(_ amount:CGFloat){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
  
  func setRightPaddingPoints(_ amount:CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.rightView = paddingView
    self.rightViewMode = .always
  }
  
  func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
    let clearButton = UIButton(type: .custom)
    clearButton.setImage(image, for: .normal)
    clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    clearButton.contentMode = .scaleAspectFit
    clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
    self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
    self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
    self.rightView = clearButton
    self.rightViewMode = mode
  }
  
  @objc private func displayClearButtonIfNeeded() {
    self.rightView?.isHidden = (self.text?.isEmpty) ?? true
  }
  
  @objc private func clear(sender: AnyObject) {
    self.text = ""
    sendActions(for: .editingChanged)
  }
}

