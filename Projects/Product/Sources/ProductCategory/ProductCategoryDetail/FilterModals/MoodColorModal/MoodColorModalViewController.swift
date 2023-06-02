//
//  MoodColorModalViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift
import UIKit
import CommonUI

protocol MoodColorModalPresentableListener: AnyObject {
    func dismissMoodColorModalVC()
}

final class MoodColorModalViewController: ModalViewController, MoodColorModalPresentable, MoodColorModalViewControllable {

    weak var listener: MoodColorModalPresentableListener?
  
  //private let disposeBag: DisposeBag = DisposeBag()
  
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.warningColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    print("AAAAA")
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.setupLayouts()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if isShow == false {
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let self else { return }
        self.modalView.pin
          .horizontally()
          .bottom()
          .height(300)
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  private func setupViews() {
    self.view.addSubview(modalView)
  }
  
  private func setupLayouts() {
    modalView.pin
      .horizontally()
      .bottom()
      .height(0)
  }
  
  private func setupGestures() {
  }
  
  override func didTapBackgroundView() {
    UIView.animate(
      withDuration: dismissAnimationDuration,
      delay: dismissAnimationDelay,
      options: dismissAnimationOption
    ) { [weak self] in
      guard let self else { return }
      self.backgroundAlphaView.alpha = 0.0
      self.modalView.pin
        .horizontally()
        .bottom()
        .height(0)
      
    } completion: { [weak self] _ in
      guard let self else { return }
      self.listener?.dismissMoodColorModalVC()
    }
  }
}
