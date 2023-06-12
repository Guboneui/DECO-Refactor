//
//  SearchUserRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchUserInteractable: Interactable {
    var router: SearchUserRouting? { get set }
    var listener: SearchUserListener? { get set }
}

protocol SearchUserViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchUserRouter: ViewableRouter<SearchUserInteractable, SearchUserViewControllable>, SearchUserRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchUserInteractable, viewController: SearchUserViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
