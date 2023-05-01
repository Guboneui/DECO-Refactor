//
//  GenderRouter.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol GenderInteractable: Interactable {
    var router: GenderRouting? { get set }
    var listener: GenderListener? { get set }
}

protocol GenderViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class GenderRouter: ViewableRouter<GenderInteractable, GenderViewControllable>, GenderRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: GenderInteractable, viewController: GenderViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
