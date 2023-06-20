//
//  LogoutRouter.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/20.
//

import RIBs

protocol LogoutInteractable: Interactable {
    var router: LogoutRouting? { get set }
    var listener: LogoutListener? { get set }
}

protocol LogoutViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LogoutRouter: ViewableRouter<LogoutInteractable, LogoutViewControllable>, LogoutRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: LogoutInteractable, viewController: LogoutViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
