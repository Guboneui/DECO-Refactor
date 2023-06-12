//
//  SearchProductRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchProductInteractable: Interactable {
    var router: SearchProductRouting? { get set }
    var listener: SearchProductListener? { get set }
}

protocol SearchProductViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchProductRouter: ViewableRouter<SearchProductInteractable, SearchProductViewControllable>, SearchProductRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchProductInteractable, viewController: SearchProductViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
