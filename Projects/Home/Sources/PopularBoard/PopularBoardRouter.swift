//
//  PopularBoardRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import RIBs

protocol PopularBoardInteractable: Interactable {
    var router: PopularBoardRouting? { get set }
    var listener: PopularBoardListener? { get set }
}

protocol PopularBoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PopularBoardRouter: ViewableRouter<PopularBoardInteractable, PopularBoardViewControllable>, PopularBoardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PopularBoardInteractable, viewController: PopularBoardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
