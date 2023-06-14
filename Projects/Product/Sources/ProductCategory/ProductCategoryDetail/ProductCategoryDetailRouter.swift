//
//  ProductCategoryDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import Util
import Entity
import ProductDetail

import RIBs

protocol ProductCategoryDetailInteractable:
  Interactable,
  CategoryModalListener,
  MoodColorModalListener,
  ProductDetailListener
{
  var router: ProductCategoryDetailRouting? { get set }
  var listener: ProductCategoryDetailListener? { get set }
}

protocol ProductCategoryDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductCategoryDetailRouter: ViewableRouter<ProductCategoryDetailInteractable, ProductCategoryDetailViewControllable>, ProductCategoryDetailRouting {
  
  private let categoryModalBuildable: CategoryModalBuildable
  private var categoryModalRouting: Routing?
  
  private let moodColorModalBuildable: MoodColorModalBuildable
  private var moodColorModalRouting: Routing?
  
  private let productDetailBuildable: ProductDetailBuildable
  private var productDetailRouting: Routing?
  
  init(
    interactor: ProductCategoryDetailInteractable,
    viewController: ProductCategoryDetailViewControllable,
    categoryModalBuildable: CategoryModalBuildable,
    moodColorModalBuildable: MoodColorModalBuildable,
    productDetailBuildable: ProductDetailBuildable
  ) {
    self.categoryModalBuildable = categoryModalBuildable
    self.moodColorModalBuildable = moodColorModalBuildable
    self.productDetailBuildable = productDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachCategoryModalVC() {
    if categoryModalRouting != nil { return }
    let router = categoryModalBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    categoryModalRouting = router
  }
  
  func detachCategoryModalVC() {
    guard let router = categoryModalRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    categoryModalRouting = nil
  }
  
  func attachMoodColorModalVC() {
    if moodColorModalRouting != nil { return }
    let router = moodColorModalBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    moodColorModalRouting = router
  }
  
  func detachMoodColorModalVC() {
    guard let router = moodColorModalRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    moodColorModalRouting = nil
  }
  
  func attachProductDetailVC(with productInfo: ProductDTO) {
    if productDetailRouting != nil { return }
    let router = productDetailBuildable.build(withListener: interactor, productInfo: productInfo)
    attachChild(router)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.productDetailRouting = router
  }
  
  func detachProductDetailVC(with popType: PopType) {
    guard let router = productDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.detachChild(router)
    self.productDetailRouting = nil
  }
}
