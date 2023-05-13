//
//  ProductCategoryRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs

protocol ProductCategoryInteractable: Interactable {
    var router: ProductCategoryRouting? { get set }
    var listener: ProductCategoryListener? { get set }
}

protocol ProductCategoryViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductCategoryRouter: ViewableRouter<ProductCategoryInteractable, ProductCategoryViewControllable>, ProductCategoryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductCategoryInteractable, viewController: ProductCategoryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
