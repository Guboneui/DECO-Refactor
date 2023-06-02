//
//  ModalViewController.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/02.
//

import UIKit
import RxSwift

import PinLayout

public protocol ModalAnimation {
  func didTapBackgroundView()
}

open class ModalViewController: UIViewController, ModalAnimation {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public let showAnimationDuration: TimeInterval = 0.25
  public let showAnimationDelay: TimeInterval = 0.0
  public let showAnimationOption: UIView.AnimationOptions = [.curveEaseIn]
  
  public let dismissAnimationDuration: TimeInterval = 0.15
  public let dismissAnimationDelay: TimeInterval = 0.0
  public let dismissAnimationOption: UIView.AnimationOptions = [.curveEaseOut]
  
  public var isShow: Bool = false
  
  public let backgroundAlphaView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.3)
    $0.alpha = 0.0
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setupViews()
    self.setupGestures()
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
    
    if isShow == false {
      UIView.animate(
        withDuration: showAnimationDuration,
        delay: showAnimationDelay,
        options: showAnimationOption
      ) { [weak self] in
        guard let self else { return }
        self.backgroundAlphaView.alpha = 1.0
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  private func setupViews() {
    self.view.addSubview(backgroundAlphaView)
  }
  
  private func setupLayouts() {
    backgroundAlphaView.pin.all()
  }
  
  private func setupGestures() {
    self.backgroundAlphaView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.didTapBackgroundView()
      }.disposed(by: disposeBag)
  }
  
  
  open func didTapBackgroundView() { }
}
