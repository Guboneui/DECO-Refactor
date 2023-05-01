//
//  LoginMainRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit

protocol LoginMainInteractable: Interactable, NickNameListener, GenderListener {
  var router: LoginMainRouting? { get set }
  var listener: LoginMainListener? { get set }

}

protocol LoginMainViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LoginMainRouter: LaunchRouter<LoginMainInteractable, NavigationControllerable>, LoginMainRouting {
  
  private var navigationControllable: NavigationControllerable?
  
  private let nicknameBuildable: NickNameBuildable
  private var nicknameRouting: Routing?
  
  private let genderBuildable: GenderBuildable
  private var genderRouting: Routing?
  
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: LoginMainInteractable,
    viewController: NavigationControllerable,
    nicknameBuildable: NickNameBuildable,
    genderBuildable: GenderBuildable
  ) {
    self.nicknameBuildable = nicknameBuildable
    self.genderBuildable = genderBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachNicknameVC() {
    if nicknameRouting != nil { return }
    let router = nicknameBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.nicknameRouting = router
  }
  
  func detachNicknameVC() {
    guard let router = nicknameRouting else { return }
    self.navigationControllable?.popViewController(animated: true)
    detachChild(router)
    nicknameRouting = nil
  }
  
  func attachGenderVC() {
    if genderRouting != nil { return }
    let router = genderBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.genderRouting = router
  }
  
  func detachGenderVC() {
    guard let router = genderRouting else { return }
    self.navigationControllable?.popViewController(animated: true)
    detachChild(router)
    genderRouting = nil
  }
}
