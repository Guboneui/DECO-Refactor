//
//  ProductMoodDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import RIBs

protocol ProductMoodDetailInteractable: Interactable {
    var router: ProductMoodDetailRouting? { get set }
    var listener: ProductMoodDetailListener? { get set }
}

protocol ProductMoodDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductMoodDetailRouter: ViewableRouter<ProductMoodDetailInteractable, ProductMoodDetailViewControllable>, ProductMoodDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductMoodDetailInteractable, viewController: ProductMoodDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
