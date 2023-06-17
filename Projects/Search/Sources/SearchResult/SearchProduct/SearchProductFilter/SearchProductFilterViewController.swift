//
//  SearchProductFilterViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/18.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
import FlexLayout

protocol SearchProductFilterPresentableListener: AnyObject {
  func dismissFilterModalVC()
}

final class SearchProductFilterViewController: ModalViewController, SearchProductFilterPresentable, SearchProductFilterViewControllable {
  
  weak var listener: SearchProductFilterPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
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
          .height(500)
          //.height(self.editFilterButtonView.frame.maxY + (UIDevice.current.hasNotch ? 40 : 24))
        
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
    
  }
  
  private func setupGestures() {
    
  }
  
  override func didTapBackgroundView() {
    self.dismissModalAnimation()
  }
  
  private func dismissModalAnimation() {
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
      self.listener?.dismissFilterModalVC()
    }
  }
}
