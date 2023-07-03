//
//  FollowBoardRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import RIBs

protocol FollowBoardInteractable: Interactable {
    var router: FollowBoardRouting? { get set }
    var listener: FollowBoardListener? { get set }
}

protocol FollowBoardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FollowBoardRouter: ViewableRouter<FollowBoardInteractable, FollowBoardViewControllable>, FollowBoardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FollowBoardInteractable, viewController: FollowBoardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
