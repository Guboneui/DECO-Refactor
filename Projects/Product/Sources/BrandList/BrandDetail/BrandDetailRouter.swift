//
//  BrandDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import Util
import Entity

import RIBs

protocol BrandDetailInteractable:
  Interactable,
  BrandProductUsageListener
{
  var router: BrandDetailRouting? { get set }
  var listener: BrandDetailListener? { get set }
}

protocol BrandDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BrandDetailRouter: ViewableRouter<BrandDetailInteractable, BrandDetailViewControllable>, BrandDetailRouting {
  
  private let brandProductUsageBuildable: BrandProductUsageBuildable
  private var brandProductUsageRouting: Routing?
  
  init(
    interactor: BrandDetailInteractable,
    viewController: BrandDetailViewControllable,
    brandProductUsageBuildable: BrandProductUsageBuildable
  ) {
    self.brandProductUsageBuildable = brandProductUsageBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachBrandProductUsage(brandInfo: BrandDTO) {
    if brandProductUsageRouting != nil { return }
    let router = brandProductUsageBuildable.build(withListener: interactor, brandInfo: brandInfo)
    self.brandProductUsageRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
  }
  
  func detachBrandProductUsageVC(with popType: PopType) {
    guard let router = brandProductUsageRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    brandProductUsageRouting = nil
    detachChild(router)
  }
}
