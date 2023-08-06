//
//  IndicatorManager.swift
//  CommonUI
//
//  Created by 구본의 on 2023/08/06.
//

import UIKit

public class IndicatorManager {
  public static let shared = IndicatorManager()
  
  private let indicator = UIActivityIndicatorView()
  private var windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
  
  public func startLoading() {
    addIndicatorView()
    indicator.startAnimating()
  }
  
  public func stopLoading(_ completion: (()->())? = nil) {
    indicator.stopAnimating()
    indicator.removeFromSuperview()
    completion?()
  }
  
  private func setupIndicatorUI() {
    indicator.backgroundColor = .DecoColor.darkGray2.withAlphaComponent(0.3)
    indicator.style = .medium
  }
  
  private func addIndicatorView() {
    if let windowScene,
       let window = windowScene.windows.first {
      setupIndicatorUI()
      window.addSubview(indicator)
      indicator.frame = window.bounds
      window.bringSubviewToFront(indicator)
    }
  }
}
