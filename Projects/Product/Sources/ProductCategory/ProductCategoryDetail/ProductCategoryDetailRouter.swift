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
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    categoryModalRouting = router
    attachChild(router)
  }
  
  func detachCategoryModalVC() {
    guard let router = categoryModalRouting else { return }
    viewControllable.dismiss(animated: false, completion: nil)
    categoryModalRouting = nil
    detachChild(router)
  }
  
  func attachMoodColorModalVC() {
    if moodColorModalRouting != nil { return }
    let router = moodColorModalBuildable.build(withListener: interactor)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    moodColorModalRouting = router
    attachChild(router)
  }
  
  func detachMoodColorModalVC() {
    guard let router = moodColorModalRouting else { return }
    viewControllable.dismiss(animated: false, completion: nil)
    moodColorModalRouting = nil
    detachChild(router)
  }
  
  func attachProductDetailVC(with productInfo: ProductDTO) {
    if productDetailRouting != nil { return }
    let router = productDetailBuildable.build(withListener: interactor, productInfo: productInfo)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.productDetailRouting = router
    attachChild(router)
  }
  
  func detachProductDetailVC(with popType: PopType) {
    guard let router = productDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.productDetailRouting = nil
    self.detachChild(router)
  }
}
