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
    attachChild(router)
    self.searchRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
  }
  
  func detachSearchVC(with popType: PopType) {
    guard let router = searchRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.detachChild(router)
    self.searchRouting = nil
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
