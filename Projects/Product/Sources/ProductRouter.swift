//
//  ProductRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs

protocol ProductInteractable: Interactable {
    var router: ProductRouting? { get set }
    var listener: ProductListener? { get set }
}

public protocol ProductViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductRouter: ViewableRouter<ProductInteractable, ProductViewControllable>, ProductRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductInteractable, viewController: ProductViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
