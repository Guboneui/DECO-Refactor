//
//  LoginMainRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit

protocol LoginMainInteractable: Interactable, NickNameListener {
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
  
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: LoginMainInteractable,
    viewController: NavigationControllerable,
    nicknameBuildable: NickNameBuildable
  ) {
    self.nicknameBuildable = nicknameBuildable
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
}
