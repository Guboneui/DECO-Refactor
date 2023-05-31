//
//  TargetUserProfileRouter.swift
//  User
//
//  Created by 구본의 on 2023/05/31.
//

import RIBs

protocol TargetUserProfileInteractable: Interactable {
    var router: TargetUserProfileRouting? { get set }
    var listener: TargetUserProfileListener? { get set }
}

protocol TargetUserProfileViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TargetUserProfileRouter: ViewableRouter<TargetUserProfileInteractable, TargetUserProfileViewControllable>, TargetUserProfileRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TargetUserProfileInteractable, viewController: TargetUserProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
