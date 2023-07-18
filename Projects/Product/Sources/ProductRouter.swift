//
//  ProductRouter.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import Util
import UIKit
import Search

protocol ProductInteractable:
  Interactable,
  ProductCategoryListener,
  BrandListListener,
SearchListener
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
  
  private let searchBuildable: SearchBuildable
  private var searchRouting: Routing?
  
  
  init(
    interactor: ProductInteractable,
    viewController: ProductViewControllable,
    productCategoryBuildable: ProductCategoryBuildable,
    brandListBuildable: BrandListBuildable,
    searchBuildable: SearchBuildable
  ) {
    self.productCategoryBuildable = productCategoryBuildable
    self.brandListBuildable = brandListBuildable
    self.searchBuildable = searchBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  override func didLoad() {
    self.attachProductCategoryRIB()
  }
  
  func attachSearchVC() {
    if searchRouting != nil { return }
    let router = searchBuildable.build(withListener: interactor)
    self.searchRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
  }
  
  func detachSearchVC(with popType: PopType) {
    guard let router = searchRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.searchRouting = nil
    self.detachChild(router)
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
    self.productCategoryRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
    attachChild(router)
  }
  
  private func detachProductCategoryRIB() {
    if let router = productCategoryRouting {
      self.productCategoryRouting = nil
      detachChild(router)
    }
  }
  
  private func attachBrandListRIB() {
    if brandListRouting != nil { return }
    let router = brandListBuildable.build(withListener: interactor)
    self.brandListRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
    attachChild(router)
  }
  
  private func detachBrandListRIB() {
    if let router = brandListRouting {
      self.brandListRouting = nil
      detachChild(router)
    }
  }
}
