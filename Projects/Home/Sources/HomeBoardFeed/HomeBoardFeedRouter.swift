//
//  HomeBoardFeedRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/25.
//

import User
import Util
import Entity
import RIBs

protocol HomeBoardFeedInteractable:
  Interactable,
  TargetUserProfileListener
{
  var router: HomeBoardFeedRouting? { get set }
  var listener: HomeBoardFeedListener? { get set }
}

protocol HomeBoardFeedViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class HomeBoardFeedRouter: ViewableRouter<HomeBoardFeedInteractable, HomeBoardFeedViewControllable>, HomeBoardFeedRouting {
  
  private let targetUserProfileBuildable: TargetUserProfileBuildable
  private var targetUserProfileRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: HomeBoardFeedInteractable,
    viewController: HomeBoardFeedViewControllable,
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
