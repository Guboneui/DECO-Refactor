//
//  MoodColorModalRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs

protocol MoodColorModalInteractable: Interactable {
    var router: MoodColorModalRouting? { get set }
    var listener: MoodColorModalListener? { get set }
}

protocol MoodColorModalViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MoodColorModalRouter: ViewableRouter<MoodColorModalInteractable, MoodColorModalViewControllable>, MoodColorModalRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MoodColorModalInteractable, viewController: MoodColorModalViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
