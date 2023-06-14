//
//  ProductDetailRouter.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import RIBs

protocol ProductDetailInteractable: Interactable {
  var router: ProductDetailRouting? { get set }
  var listener: ProductDetailListener? { get set }
}

protocol ProductDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductDetailRouter: ViewableRouter<ProductDetailInteractable, ProductDetailViewControllable>, ProductDetailRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: ProductDetailInteractable, viewController: ProductDetailViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
