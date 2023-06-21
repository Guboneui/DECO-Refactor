//
//  ToastManager.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/21.
//

import UIKit

public class ToastManager {
  public static let shared = ToastManager()
  
  private var window = UIApplication.shared.connectedScenes.first as? UIWindowScene
  private var currentToast: Bool = false
  
  public func showToast(_ toastMessage: String) {
    if let windowScene = window,
       let rootVC = windowScene.windows.first?.rootViewController,
       currentToast == false {
      
      currentToast = true
      let toastContainerView: UIView = UIView().then {
        $0.backgroundColor = .DecoColor.darkGray2
        $0.alpha = 0.0
        $0.makeCornerRadius(radius: 4)
      }
      
      let toastLabel: UILabel = UILabel().then {
        $0.text = toastMessage
        $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
        $0.textColor = .DecoColor.whiteColor
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
      }
      
      rootVC.view.addSubview(toastContainerView)
      toastContainerView.addSubview(toastLabel)
      toastContainerView.pin
        .bottom(rootVC.view.pin.safeArea)
        .horizontally(20)

      toastLabel.pin
        .vertically()
        .horizontally(20)
        .sizeToFit(.width)
      
      toastContainerView.pin.wrapContent(.vertically, padding: 12)
      
      rootVC.view.bringSubviewToFront(toastContainerView)
      showAnimation(at: rootVC, with: toastContainerView)
    }
  }
  
  private func showAnimation(at rootVC: UIViewController, with toastView: UIView) {
    UIView.animate(
      withDuration: 0.3,
      delay: 0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      options: .curveEaseIn,
      animations: {
        toastView.pin
        .bottom(100)
        .horizontally(20)

        toastView.alpha = 1.0
    }) { [weak self] _ in
      self?.hideAnimation(at: rootVC, with: toastView)
      
    }
  }
  
  private func hideAnimation(at rootVC: UIViewController, with toastView: UIView) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      self?.currentToast = false
      UIView.animate(
        withDuration: 0.3,
        delay: 0.0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: .curveEaseIn
      ) {
        toastView.alpha = 0.0
        toastView.pin
          .bottom(rootVC.view.pin.safeArea)
          .horizontally(20)
      }
    }
  }
}
