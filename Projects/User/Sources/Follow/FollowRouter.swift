//
//  FollowRouter.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import RIBs

protocol FollowInteractable:
  Interactable,
  FollowerListListener,
  FollowingListListener
{
  var router: FollowRouting? { get set }
  var listener: FollowListener? { get set }
  
  var followerListViewControllerable: ViewControllable? { get set }
  var followingListViewControllerable: ViewControllable? { get set }
}

protocol FollowViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FollowRouter: ViewableRouter<FollowInteractable, FollowViewControllable>, FollowRouting {
  
  private let followerListBuildable: FollowerListBuildable
  private var followerListRouting: Routing?
  
  private let followingListBuildable: FollowingListBuildable
  private var followingListRouting: Routing?
  
  init(
    interactor: FollowInteractable,
    viewController: FollowViewControllable,
    followerListBuildable: FollowerListBuildable,
    followingListBuildable: FollowingListBuildable,
    targetUserID: Int
  ) {
    self.followerListBuildable = followerListBuildable
    self.followingListBuildable = followingListBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    self.attachFollowerListRIB(targetUserID: targetUserID)
    self.attachFollowingListRIB(targetUserID: targetUserID)
  }
  
  deinit {
    self.detachFollowerListRIB()
    self.detachFollowingListRIB()
  }
  
  private func attachFollowerListRIB(targetUserID: Int) {
    if followerListRouting != nil { return }
    let router = followerListBuildable.build(withListener: interactor, targetUserID: targetUserID)
    attachChild(router)
    self.interactor.followerListViewControllerable = router.viewControllable
    self.followerListRouting = router
  }
  
  private func detachFollowerListRIB() {
    guard let router = followerListRouting else { return }
    self.detachChild(router)
    self.followerListRouting = nil
  }
  
  private func attachFollowingListRIB(targetUserID: Int) {
    if followingListRouting != nil { return }
    let router = followingListBuildable.build(withListener: interactor, targetUserID: targetUserID)
    attachChild(router)
    self.interactor.followingListViewControllerable = router.viewControllable
    self.followingListRouting = router
  }
  
  private func detachFollowingListRIB() {
    guard let router = followingListRouting else { return }
    self.detachChild(router)
    self.followingListRouting = nil
  }
}
