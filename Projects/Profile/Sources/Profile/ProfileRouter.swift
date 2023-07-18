//
//  ProfileRouter.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import Util
import User
import Entity
import AppSetting

import RIBs

protocol ProfileInteractable:
  Interactable,
  AppSettingListener,
  ProfileEditListener,
  FollowListener
{
  var router: ProfileRouting? { get set }
  var listener: ProfileListener? { get set }
}

public protocol ProfileViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileRouter: ViewableRouter<ProfileInteractable, ProfileViewControllable>, ProfileRouting {
  
  private let appSettingBuildable: AppSettingBuildable
  private var appSettingRouting: Routing?
  
  private let profileEditBuildable: ProfileEditBuildable
  private var profileEditRouting: Routing?
  
  private let followBuildable: FollowBuildable
  private var followRouting: Routing?
  
  init(
    interactor: ProfileInteractable,
    viewController: ProfileViewControllable,
    appSettingBuildable: AppSettingBuildable,
    profileEditBuildable: ProfileEditBuildable,
    followBuildable: FollowBuildable
  ) {
    self.appSettingBuildable = appSettingBuildable
    self.profileEditBuildable = profileEditBuildable
    self.followBuildable = followBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachAppSettingVC() {
    if appSettingRouting != nil { return }
    let router = appSettingBuildable.build(withListener: interactor)
    self.appSettingRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
  }
  
  func detachAppSettingVC(with popType: PopType) {
    guard let router = appSettingRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.appSettingRouting = nil
    self.detachChild(router)
  }
  
  func attachProfileEditVC() {
    if profileEditRouting != nil { return }
    let router = profileEditBuildable.build(withListener: interactor)
    self.profileEditRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
  }
  
  func detachProfileEditVC(with popType: PopType) {
    guard let router = profileEditRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.profileEditRouting = nil
    self.detachChild(router)
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
