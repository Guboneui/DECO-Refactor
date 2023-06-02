//
//  CategoryModalRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs

protocol CategoryModalInteractable: Interactable {
  var router: CategoryModalRouting? { get set }
  var listener: CategoryModalListener? { get set }
}

protocol CategoryModalViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CategoryModalRouter: ViewableRouter<CategoryModalInteractable, CategoryModalViewControllable>, CategoryModalRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: CategoryModalInteractable, viewController: CategoryModalViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
