//
//  BrandProductUsageRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/24.
//

import RIBs

protocol BrandProductUsageInteractable: Interactable {
  var router: BrandProductUsageRouting? { get set }
  var listener: BrandProductUsageListener? { get set }
}

protocol BrandProductUsageViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BrandProductUsageRouter: ViewableRouter<BrandProductUsageInteractable, BrandProductUsageViewControllable>, BrandProductUsageRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: BrandProductUsageInteractable, viewController: BrandProductUsageViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
