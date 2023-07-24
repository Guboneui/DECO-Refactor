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
  HomeBoardFeedListener
{
  var router: LatestBoardRouting? { get set }
  var listener: LatestBoardListener? { get set }
  
}

protocol LatestBoardViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LatestBoardRouter: ViewableRouter<LatestBoardInteractable, LatestBoardViewControllable>, LatestBoardRouting {
  
  private let homeBoardFeedBuildable: HomeBoardFeedBuildable
  private var homeBoardFeedRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: LatestBoardInteractable,
    viewController: LatestBoardViewControllable,
    homeBoardFeedBuildable: HomeBoardFeedBuildable
  ) {
    self.homeBoardFeedBuildable = homeBoardFeedBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachHomeBoardFeedRIB(at startIndex: Int, type: HomeType) {
    if homeBoardFeedRouting != nil { return }
    let router = homeBoardFeedBuildable.build(
      withListener: interactor,
      startIndex: startIndex,
      feedType: type
    )
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.homeBoardFeedRouting = router
    attachChild(router)
  }
  
  func detachHomeBoardFeedRIB(with popType: PopType) {
    guard let router = homeBoardFeedRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    
    self.homeBoardFeedRouting = nil
    self.detachChild(router)
  }
}


