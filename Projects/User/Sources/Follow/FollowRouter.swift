//
//  FollowRouter.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Entity
import Util
import RIBs
import RxRelay

protocol FollowInteractable:
  Interactable,
  FollowerListListener,
  FollowingListListener,
  TargetUserProfileListener
{
  var router: FollowRouting? { get set }
  var listener: FollowListener? { get set }
}

protocol FollowViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
  var followViewControllers: BehaviorRelay<[ViewControllable]> { get set }
}

final class FollowRouter: ViewableRouter<FollowInteractable, FollowViewControllable>, FollowRouting {
  
  private let followerListBuildable: FollowerListBuildable
  private var followerListRouting: Routing?
  
  private let followingListBuildable: FollowingListBuildable
  private var followingListRouting: Routing?
  
  private let targetUserProfileBuildable: TargetUserProfileBuildable
  private var targetUserProfileRouting: Routing?
  
  init(
    interactor: FollowInteractable,
    viewController: FollowViewControllable,
    followerListBuildable: FollowerListBuildable,
    followingListBuildable: FollowingListBuildable,
    targetUserProfileBuildable: TargetUserProfileBuildable,
    targetUserID: Int
  ) {
    self.followerListBuildable = followerListBuildable
    self.followingListBuildable = followingListBuildable
    self.targetUserProfileBuildable = targetUserProfileBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    attachFollowListRIB(targetUserID: targetUserID)
  }
  
  deinit {
    self.detachFollowListRIB()
  }
  
  private func attachFollowListRIB(targetUserID: Int) {
    if followerListRouting != nil { return }
    let followerListRouter = followerListBuildable.build(withListener: interactor, targetUserID: targetUserID)
    
    if followingListRouting != nil { return }
    let followingListRouter = followingListBuildable.build(withListener: interactor, targetUserID: targetUserID)
    
    self.followerListRouting = followerListRouter
    self.followingListRouting = followingListRouter
    attachChild(followerListRouter)
    attachChild(followingListRouter)
    
    let followerListViewController = followerListRouter.viewControllable
    let followingListViewController = followingListRouter.viewControllable
    
    viewController.followViewControllers.accept([followerListViewController, followingListViewController])
  }
  
  private func detachFollowListRIB() {
    guard let followerListRouter = followerListRouting,
          let followingListRouter = followingListRouting else { return }
    
    self.followerListRouting = nil
    self.followingListRouting = nil
  
    self.detachChild(followerListRouter)
    self.detachChild(followingListRouter)
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
