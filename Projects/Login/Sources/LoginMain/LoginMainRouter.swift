//
//  LoginMainRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit

protocol LoginMainInteractable:
  Interactable,
  NickNameListener
{
  var router: LoginMainRouting? { get set }
  var listener: LoginMainListener? { get set }
}

public protocol LoginMainViewControllable: ViewControllable {
  
}

final class LoginMainRouter: ViewableRouter<LoginMainInteractable, NavigationControllerable>, LoginMainRouting {
  
  private var navigationControllable: NavigationControllerable?

  private let nicknameBuildable: NickNameBuildable
  private var nicknameRouting: Routing?
  
  init(
    interactor: LoginMainInteractable,
    navigationController: NavigationControllerable,
    nicknameBuildable: NickNameBuildable
  ) {
    self.nicknameBuildable = nicknameBuildable
    super.init(interactor: interactor, viewController: navigationController)
    interactor.router = self
    self.navigationControllable = viewController
  }
  
  func attachNicknameVC() {
    if nicknameRouting != nil { return }
    let router = nicknameBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.nicknameRouting = router
  }

  func detachNicknameVC(with popType: PopType) {
    guard let router = nicknameRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    detachChild(router)
    nicknameRouting = nil
  }
}
