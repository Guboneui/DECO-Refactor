//
//  LoginMainRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs

protocol LoginMainInteractable: Interactable {
  var router: LoginMainRouting? { get set }
  var listener: LoginMainListener? { get set }
}

protocol LoginMainViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LoginMainRouter: LaunchRouter<LoginMainInteractable, LoginMainViewControllable>, LoginMainRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: LoginMainInteractable, viewController: LoginMainViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
