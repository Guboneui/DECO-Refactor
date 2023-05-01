//
//  MoodRouter.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol MoodInteractable: Interactable {
    var router: MoodRouting? { get set }
    var listener: MoodListener? { get set }
}

protocol MoodViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MoodRouter: ViewableRouter<MoodInteractable, MoodViewControllable>, MoodRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MoodInteractable, viewController: MoodViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
