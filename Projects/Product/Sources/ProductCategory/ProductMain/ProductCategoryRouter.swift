//
//  ProductCategoryRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import Util

import RIBs

protocol ProductCategoryInteractable:
  Interactable,
  ProductCategoryDetailListener,
  ProductMoodDetailListener
{
  var router: ProductCategoryRouting? { get set }
  var listener: ProductCategoryListener? { get set }
}

protocol ProductCategoryViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductCategoryRouter: ViewableRouter<ProductCategoryInteractable, ProductCategoryViewControllable>, ProductCategoryRouting {
  
  
  private let productCategoryDetailBuildable: ProductCategoryDetailBuildable
  private var productCategoryDetailRouting: Routing?
  
  private let productMoodDetailBuildable: ProductMoodDetailBuildable
  private var productMoodDetailRouting: Routing?
  
  init(
    interactor: ProductCategoryInteractable,
    viewController: ProductCategoryViewControllable,
    productCategoryDetailBuildable: ProductCategoryDetailBuildable,
    productMoodDetailBuildable: ProductMoodDetailBuildable
  ) {
    self.productCategoryDetailBuildable = productCategoryDetailBuildable
    self.productMoodDetailBuildable = productMoodDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachProductCategoryDetailVC() {
    if productCategoryDetailRouting != nil { return }
    let router = productCategoryDetailBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.productCategoryDetailRouting = router
    attachChild(router)
  }
  
  func detachProductCategoryDetailVC(with popType: PopType) {
    guard let router = productCategoryDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.productCategoryDetailRouting = nil
    detachChild(router)
  }
  
  func attachProductMoodDetailVC() {
    if productMoodDetailRouting != nil { return }
    let router = productMoodDetailBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.productMoodDetailRouting = router
    attachChild(router)
  }
  
  func detachProductMoodDetailVC(with popType: PopType) {
    guard let router = productMoodDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.productMoodDetailRouting = nil
    self.detachChild(router)
  }
}

