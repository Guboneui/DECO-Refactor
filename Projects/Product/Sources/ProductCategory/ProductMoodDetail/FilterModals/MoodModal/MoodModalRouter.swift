//
//  MoodModalRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import RIBs

protocol MoodModalInteractable: Interactable {
    var router: MoodModalRouting? { get set }
    var listener: MoodModalListener? { get set }
}

protocol MoodModalViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MoodModalRouter: ViewableRouter<MoodModalInteractable, MoodModalViewControllable>, MoodModalRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MoodModalInteractable, viewController: MoodModalViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
