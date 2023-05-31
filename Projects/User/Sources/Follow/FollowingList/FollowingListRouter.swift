//
//  FollowingListRouter.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Util
import Entity

import RIBs

protocol FollowingListInteractable:
  Interactable,
  TargetUserProfileListener
{
  var router: FollowingListRouting? { get set }
  var listener: FollowingListListener? { get set }
}

protocol FollowingListViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FollowingListRouter: ViewableRouter<FollowingListInteractable, FollowingListViewControllable>, FollowingListRouting {
  
  private let targetUserProfileBuildable: TargetUserProfileBuildable
  private var targetUserProfileRouting: Routing?
  
  init(
    interactor: FollowingListInteractable,
    viewController: FollowingListViewControllable,
    targetUserProfileBuildable: TargetUserProfileBuildable
  ) {
    self.targetUserProfileBuildable = targetUserProfileBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO) {
    if targetUserProfileRouting != nil { return }
    let router = targetUserProfileBuildable.build(withListener: interactor, targetUserInfo: targetUserInfo)
    attachChild(router)
    self.viewController.pushViewController(router.viewControllable, animated: true)
    self.targetUserProfileRouting = router
  }
  
  func detachTargetUserProfileVC(with popType: PopType) {
    guard let router = targetUserProfileRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.detachChild(router)
    self.targetUserProfileRouting = nil
  }
  
}
