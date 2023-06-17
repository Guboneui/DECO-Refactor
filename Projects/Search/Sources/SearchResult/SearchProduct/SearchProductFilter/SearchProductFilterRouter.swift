//
//  SearchProductFilterRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/18.
//

import RIBs

protocol SearchProductFilterInteractable: Interactable {
    var router: SearchProductFilterRouting? { get set }
    var listener: SearchProductFilterListener? { get set }
}

protocol SearchProductFilterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchProductFilterRouter: ViewableRouter<SearchProductFilterInteractable, SearchProductFilterViewControllable>, SearchProductFilterRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchProductFilterInteractable, viewController: SearchProductFilterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
