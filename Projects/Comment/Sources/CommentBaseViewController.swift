//
//  CommentBaseViewController.swift
//  Comment
//
//  Created by 구본의 on 2023/07/25.
//

import RIBs
import RxSwift
import UIKit
import CommonUI

protocol CommentBasePresentableListener: AnyObject {
  func dismissCommentVC()
}

final class CommentBaseViewController: ModalViewController, CommentBasePresentable, CommentBaseViewControllable {
  
  weak var listener: CommentBasePresentableListener?
  
  private let containerView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadius(radius: 13)
  }
  
  private let handleView: HandleView = HandleView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
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
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        self.containerView.pin
          .horizontally()
          .bottom()
          .height(screenHeight * 0.75)
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  override func didTapBackgroundView() {
    UIView.animate(
      withDuration: dismissAnimationDuration,
      delay: dismissAnimationDelay,
      options: dismissAnimationOption
    ) { [weak self] in
      guard let self else { return }
      self.backgroundAlphaView.alpha = 0.0
      self.containerView.pin
        .horizontally()
        .bottom()
        .height(0)
    } completion: { [weak self] _ in
      guard let self else { return }
      self.listener?.dismissCommentVC()
    }
  }
  
  private func setupViews() {
    self.view.addSubview(containerView)
    self.containerView.addSubview(handleView)
  }
  
  private func setupLayouts() {
    containerView.pin
      .horizontally()
      .bottom()
      .height(0)
    
    handleView.pin
      .top()
      .horizontally()
      .height(20)
  }
  
  func addCommentVC(_ view: ViewControllable) {
    let vc = view.uiviewController
    addChild(vc)
    containerView.addSubview(vc.view)
    vc.view.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    vc.didMove(toParent: self)
  }
}
