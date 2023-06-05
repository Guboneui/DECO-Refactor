//
//  CategoryColorModalRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import RIBs

protocol CategoryColorModalInteractable: Interactable {
    var router: CategoryColorModalRouting? { get set }
    var listener: CategoryColorModalListener? { get set }
}

protocol CategoryColorModalViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CategoryColorModalRouter: ViewableRouter<CategoryColorModalInteractable, CategoryColorModalViewControllable>, CategoryColorModalRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CategoryColorModalInteractable, viewController: CategoryColorModalViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
