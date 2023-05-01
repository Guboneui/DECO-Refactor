//
//  AgeRouter.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol AgeInteractable: Interactable {
    var router: AgeRouting? { get set }
    var listener: AgeListener? { get set }
}

protocol AgeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AgeRouter: ViewableRouter<AgeInteractable, AgeViewControllable>, AgeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AgeInteractable, viewController: AgeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
