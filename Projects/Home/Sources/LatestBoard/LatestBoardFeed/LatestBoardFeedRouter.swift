//
//  LatestBoardFeedRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import User
import Util
import Entity
import RIBs

protocol LatestBoardFeedInteractable:
  Interactable,
  TargetUserProfileListener
{
  var router: LatestBoardFeedRouting? { get set }
  var listener: LatestBoardFeedListener? { get set }
}

protocol LatestBoardFeedViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LatestBoardFeedRouter: ViewableRouter<LatestBoardFeedInteractable, LatestBoardFeedViewControllable>, LatestBoardFeedRouting {
  
  private let targetUserProfileBuildable: TargetUserProfileBuildable
  private var targetUserProfileRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: LatestBoardFeedInteractable,
    viewController: LatestBoardFeedViewControllable,
    targetUserProfileBuildable: TargetUserProfileBuildable
  ) {
    self.targetUserProfileBuildable = targetUserProfileBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO) {
    if targetUserProfileRouting != nil { return }
    let router = targetUserProfileBuildable.build(withListener: interactor, targetUserInfo: targetUserInfo)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.targetUserProfileRouting = router
    attachChild(router)
  }
  
  func detachTargetUserProfileVC(with popType: PopType) {
    guard let router = targetUserProfileRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.targetUserProfileRouting = nil
    self.detachChild(router)
  }
}
