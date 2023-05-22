//
//  BrandDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import Entity

import RIBs

protocol BrandDetailInteractable: Interactable {
  var router: BrandDetailRouting? { get set }
  var listener: BrandDetailListener? { get set }
}

protocol BrandDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BrandDetailRouter: ViewableRouter<BrandDetailInteractable, BrandDetailViewControllable>, BrandDetailRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: BrandDetailInteractable, viewController: BrandDetailViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
