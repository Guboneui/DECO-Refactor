//
//  WithdrawRouter.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/21.
//

import RIBs

protocol WithdrawInteractable: Interactable {
    var router: WithdrawRouting? { get set }
    var listener: WithdrawListener? { get set }
}

protocol WithdrawViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WithdrawRouter: ViewableRouter<WithdrawInteractable, WithdrawViewControllable>, WithdrawRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WithdrawInteractable, viewController: WithdrawViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
