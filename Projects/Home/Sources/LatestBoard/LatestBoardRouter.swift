//
//  LatestBoardRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import RIBs

protocol LatestBoardInteractable: Interactable {
    var router: LatestBoardRouting? { get set }
    var listener: LatestBoardListener? { get set }
}

protocol LatestBoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LatestBoardRouter: ViewableRouter<LatestBoardInteractable, LatestBoardViewControllable>, LatestBoardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: LatestBoardInteractable, viewController: LatestBoardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
