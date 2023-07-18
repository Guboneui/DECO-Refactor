//
//  TargetUserProfileRouter.swift
//  User
//
//  Created by 구본의 on 2023/05/31.
//

import Util

import RIBs

protocol TargetUserProfileInteractable: Interactable, FollowListener {
  var router: TargetUserProfileRouting? { get set }
  var listener: TargetUserProfileListener? { get set }
}

protocol TargetUserProfileViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TargetUserProfileRouter: ViewableRouter<TargetUserProfileInteractable, TargetUserProfileViewControllable>, TargetUserProfileRouting {
  
  private let followBuildable: FollowBuildable
  private var followRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: TargetUserProfileInteractable,
    viewController: TargetUserProfileViewControllable,
    followBuildable: FollowBuildable
  ) {
    self.followBuildable = followBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachFollowVC(targetUserID: Int, targetUserNickname: String, firstFollowTabStatus: FollowTabType) {
    if followRouting != nil { return }
    let router = followBuildable.build(
      withListener: interactor,
      targetUserID: targetUserID,
      targetUserNickname: targetUserNickname,
      firstFollowTabStatus: firstFollowTabStatus
    )
    self.followRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
  }
  
  func detachFollowVC(with popType: PopType) {
    guard let router = followRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.followRouting = nil
    self.detachChild(router)
  }
}
