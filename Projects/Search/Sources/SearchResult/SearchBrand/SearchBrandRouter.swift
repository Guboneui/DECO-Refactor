//
//  SearchBrandRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchBrandInteractable: Interactable {
    var router: SearchBrandRouting? { get set }
    var listener: SearchBrandListener? { get set }
}

protocol SearchBrandViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchBrandRouter: ViewableRouter<SearchBrandInteractable, SearchBrandViewControllable>, SearchBrandRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SearchBrandInteractable, viewController: SearchBrandViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
