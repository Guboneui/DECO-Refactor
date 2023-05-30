//
//  FollowingListRouter.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import RIBs

protocol FollowingListInteractable: Interactable {
    var router: FollowingListRouting? { get set }
    var listener: FollowingListListener? { get set }
}

protocol FollowingListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FollowingListRouter: ViewableRouter<FollowingListInteractable, FollowingListViewControllable>, FollowingListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FollowingListInteractable, viewController: FollowingListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
