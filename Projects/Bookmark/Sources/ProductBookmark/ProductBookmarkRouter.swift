//
//  ProductBookmarkRouter.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs

protocol ProductBookmarkInteractable: Interactable {
    var router: ProductBookmarkRouting? { get set }
    var listener: ProductBookmarkListener? { get set }
}

protocol ProductBookmarkViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductBookmarkRouter: ViewableRouter<ProductBookmarkInteractable, ProductBookmarkViewControllable>, ProductBookmarkRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProductBookmarkInteractable, viewController: ProductBookmarkViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
