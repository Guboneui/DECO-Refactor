//
//  BrandListRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import Util
import Entity

import RIBs

protocol BrandListInteractable:
  Interactable,
  BrandDetailListener
{
  var router: BrandListRouting? { get set }
  var listener: BrandListListener? { get set }
}

protocol BrandListViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BrandListRouter: ViewableRouter<BrandListInteractable, BrandListViewControllable>, BrandListRouting {
  
  private let brandDetailBuildable: BrandDetailBuildable
  private var brandDetailRouting: Routing?

  init(
    interactor: BrandListInteractable,
    viewController: BrandListViewControllable,
    brandDetailBuildable: BrandDetailBuildable
  ) {
    self.brandDetailBuildable = brandDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachBrandDetailVC(brandInfo: BrandDTO) {
    if brandDetailRouting != nil { return }
    let router = brandDetailBuildable.build(
      withListener: interactor,
      brandInfo: brandInfo
    )
    self.attachChild(router)
    self.brandDetailRouting = router
    
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
  }
  
  func detachBrandDetailVC(with popType: PopType) {
    guard let router = brandDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.detachChild(router)
    self.brandDetailRouting = nil
  }
}
