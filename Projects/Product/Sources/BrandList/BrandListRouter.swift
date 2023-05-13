//
//  BrandListRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs

protocol BrandListInteractable: Interactable {
    var router: BrandListRouting? { get set }
    var listener: BrandListListener? { get set }
}

protocol BrandListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BrandListRouter: ViewableRouter<BrandListInteractable, BrandListViewControllable>, BrandListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BrandListInteractable, viewController: BrandListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
