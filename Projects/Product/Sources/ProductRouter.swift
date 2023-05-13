//
//  ProductRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import Util
import UIKit

protocol ProductInteractable:
  Interactable,
  ProductCategoryListener,
  BrandListListener
{
  var router: ProductRouting? { get set }
  var listener: ProductListener? { get set }
}

protocol ProductViewControllable: ViewControllable {
  func setChildVCLayout(childVC: ViewControllable)
}

final class ProductRouter: ViewableRouter<ProductInteractable, ProductViewControllable>, ProductRouting {
  
  private let productCategoryBuildable: ProductCategoryBuildable
  private var productCategoryRouting: Routing?
  
  private let brandListBuildable: BrandListBuildable
  private var brandListRouting: Routing?
  
  init(
    interactor: ProductInteractable,
    viewController: ProductViewControllable,
    productCategoryBuildable: ProductCategoryBuildable,
    brandListBuildable: BrandListBuildable
  ) {
    self.productCategoryBuildable = productCategoryBuildable
    self.brandListBuildable = brandListBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  override func didLoad() {
    self.attachProductCategoryRIB()
  }
  
  func attachSearchVC() {

  }
  
  func attachChildVCRib(with type: ProductTabType) {
    switch type {
    case .Product:
      self.attachProductCategoryRIB()
      self.detachBrandListRIB()
    case .Brand:
      self.attachBrandListRIB()
      self.detachProductCategoryRIB()
    }
  }
}

extension ProductRouter {
  private func attachProductCategoryRIB() {
    if productCategoryRouting != nil { return }
    let router = productCategoryBuildable.build(withListener: interactor)
    attachChild(router)
    self.productCategoryRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
  }
  
  private func detachProductCategoryRIB() {
    if let router = productCategoryRouting {
      detachChild(router)
      self.productCategoryRouting = nil
    }
  }
  
  private func attachBrandListRIB() {
    if brandListRouting != nil { return }
    let router = brandListBuildable.build(withListener: interactor)
    attachChild(router)
    self.brandListRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
  }
  
  private func detachBrandListRIB() {
    if let router = brandListRouting {
      detachChild(router)
      self.brandListRouting = nil
    }
  }
}
