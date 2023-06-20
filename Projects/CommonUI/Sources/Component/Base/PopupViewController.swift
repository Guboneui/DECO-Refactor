//
//  PopupViewController.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/20.
//

import UIKit
import RxSwift

open class PopupViewController: UIViewController {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public let bgView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.6)
    $0.alpha = 0.0
  }
  
  public let baseView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.alpha = 0.0
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
  }
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.popupAnimation()
  }
  
  private func setupViews() {
    self.view.addSubview(bgView)
    self.view.addSubview(baseView)
  }
  
  private func setupLayouts() {
    bgView.pin.all()
    baseView.pin
      .vCenter()
      .horizontally(18)
      .wrapContent(.vertically)
  }
  
  public func popupAnimation() {
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
      guard let self = self else { return }
      self.bgView.alpha = 1.0
      self.baseView.alpha = 1.0
    }
  }
  
  public func hideAnimation(_ completion: (()->())?) {
    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
      guard let self = self else { return }
      self.bgView.alpha = 0.0
      self.baseView.alpha = 0.0
    } completion: { _ in
      completion?()
    }
  }
}
