//
//  LatestBoardFeedRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import RIBs

protocol LatestBoardFeedInteractable: Interactable {
    var router: LatestBoardFeedRouting? { get set }
    var listener: LatestBoardFeedListener? { get set }
}

protocol LatestBoardFeedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LatestBoardFeedRouter: ViewableRouter<LatestBoardFeedInteractable, LatestBoardFeedViewControllable>, LatestBoardFeedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: LatestBoardFeedInteractable, viewController: LatestBoardFeedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
