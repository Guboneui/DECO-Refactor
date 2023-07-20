//
//  LatestBoardRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import Util

import RIBs

protocol LatestBoardInteractable:
  Interactable,
  LatestBoardFeedListener
{
  var router: LatestBoardRouting? { get set }
  var listener: LatestBoardListener? { get set }
  
}

protocol LatestBoardViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LatestBoardRouter: ViewableRouter<LatestBoardInteractable, LatestBoardViewControllable>, LatestBoardRouting {
  
  private let latestBoardFeedBuildable: LatestBoardFeedBuildable
  private var latestBoardFeedRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: LatestBoardInteractable,
    viewController: LatestBoardViewControllable,
    latestBoardFeedBuildable: LatestBoardFeedBuildable
  ) {
    self.latestBoardFeedBuildable = latestBoardFeedBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachLatestBoardFeedRIB() {
    if latestBoardFeedRouting != nil { return }
    let router = latestBoardFeedBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.latestBoardFeedRouting = router
    attachChild(router)
  }
  
  func detachLatestBoardFeedRIB(with popType: PopType) {
    guard let router = latestBoardFeedRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    
    self.latestBoardFeedRouting = nil
    self.detachChild(router)
  }
}


