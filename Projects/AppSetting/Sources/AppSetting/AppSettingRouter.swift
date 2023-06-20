//
//  AppSettingRouter.swift
//  Profile
//
//  Created by 구본의 on 2023/05/27.
//

import RIBs

protocol AppSettingInteractable:
  Interactable,
  LogoutListener,
  WithdrawListener
{
  var router: AppSettingRouting? { get set }
  var listener: AppSettingListener? { get set }
}

protocol AppSettingViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppSettingRouter: ViewableRouter<AppSettingInteractable, AppSettingViewControllable>, AppSettingRouting {
  
  private let logoutBuildable: LogoutBuildable
  private var logoutRouting: Routing?
  
  private let withdrawBuildable: WithdrawBuildable
  private var withdrawRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: AppSettingInteractable,
    viewController: AppSettingViewControllable,
    logoutBuildable: LogoutBuildable,
    withdrawBuildable: WithdrawBuildable
  ) {
    self.logoutBuildable = logoutBuildable
    self.withdrawBuildable = withdrawBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachLogoutPopupVC() {
    if logoutRouting != nil { return }
    let router = logoutBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    logoutRouting = router
  }
  
  func detachLogoutPopupVC() {
    guard let router = logoutRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    logoutRouting = nil
  }
  
  func attachWithdrawPopupVC() {
    if withdrawRouting != nil { return }
    let router = withdrawBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    withdrawRouting = router
  }
  
  func detachWithdrawPopupVC() {
    guard let router = withdrawRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    withdrawRouting = nil
  }
}
