//
//  AdaptivePresentationControllerDelegate.swift
//  Util
//
//  Created by 구본의 on 2023/04/25.
//

import UIKit

public protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

public final class AdaptivePresntationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  public weak var delegate: AdaptivePresentationControllerDelegate?
  
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}

