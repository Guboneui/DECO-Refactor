//
//  NickNameRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs

protocol NickNameInteractable: Interactable {
    var router: NickNameRouting? { get set }
    var listener: NickNameListener? { get set }
}

protocol NickNameViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NickNameRouter: ViewableRouter<NickNameInteractable, NickNameViewControllable>, NickNameRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NickNameInteractable, viewController: NickNameViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
