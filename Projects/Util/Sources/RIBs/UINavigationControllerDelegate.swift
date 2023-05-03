//
//  UINavigationControllerDelegate.swift
//  Util
//
//  Created by 구본의 on 2023/05/03.
//

import UIKit

public protocol NavigationControllerDelegate: AnyObject {
  //func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
  func navigationController()
}

public final class NavigationControllerDelegateProxy: NSObject, UINavigationControllerDelegate {
  public weak var delegate: NavigationControllerDelegate?
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//    delegate?.navigationController(navigationController, didShow: viewController, animated: animated)
    delegate?.navigationController()
  }
}
