//
//  ProductCategoryDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import RIBs

protocol ProductCategoryDetailInteractable: Interactable {
    var router: ProductCategoryDetailRouting? { get set }
    var listener: ProductCategoryDetailListener? { get set }
}

protocol ProductCategoryDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductCategoryDetailRouter: ViewableRouter<ProductCategoryDetailInteractable, ProductCategoryDetailViewControllable>, ProductCategoryDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductCategoryDetailInteractable, viewController: ProductCategoryDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
