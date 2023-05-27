//
//  ProfileRouter.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import Util

import RIBs

protocol ProfileInteractable:
  Interactable,
  AppSettingListener
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
  
  init(interactor: ProfileInteractable,
       viewController: ProfileViewControllable,
       appSettingBuildable: AppSettingBuildable
  ) {
    self.appSettingBuildable = appSettingBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachAppSettingVC() {
    if appSettingRouting != nil { return }
    let router = appSettingBuildable.build(withListener: interactor)
    attachChild(router)
    self.appSettingRouting = router
    self.viewController.pushViewController(router.viewControllable, animated: true)
  }
  
  func detachAppSettingVC(with popType: PopType) {
    guard let router = appSettingRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.detachChild(router)
    self.appSettingRouting = nil
  }
}
