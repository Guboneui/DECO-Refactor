//
//  ProductMoodDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import Util
import Entity
import ProductDetail

import RIBs

protocol ProductMoodDetailInteractable:
  Interactable,
  MoodModalListener,
  CategoryColorModalListener,
  ProductDetailListener
{
  var router: ProductMoodDetailRouting? { get set }
  var listener: ProductMoodDetailListener? { get set }
}

protocol ProductMoodDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductMoodDetailRouter: ViewableRouter<ProductMoodDetailInteractable, ProductMoodDetailViewControllable>, ProductMoodDetailRouting {
  
  private let moodModalBuildable: MoodModalBuildable
  private var moodModalRouting: Routing?
  
  private let categoryColorModalBuildable: CategoryColorModalBuildable
  private var categoryColorModalRouting: Routing?
  
  private let productDetailBuildable: ProductDetailBuildable
  private var productDetailRouting: Routing?
  
  init(
    interactor: ProductMoodDetailInteractable,
    viewController: ProductMoodDetailViewControllable,
    moodModalBuildable: MoodModalBuildable,
    categoryColorModalBuildable: CategoryColorModalBuildable,
    productDetailBuildable: ProductDetailBuildable
  ) {
    self.moodModalBuildable = moodModalBuildable
    self.categoryColorModalBuildable = categoryColorModalBuildable
    self.productDetailBuildable = productDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachMoodModalVC() {
    if moodModalRouting != nil { return }
    let router = moodModalBuildable.build(withListener: interactor)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    moodModalRouting = router
    attachChild(router)
  }
  
  func detachMoodModalVC() {
    guard let router = moodModalRouting else { return }
    viewControllable.dismiss(animated: false, completion: nil)
    moodModalRouting = nil
    detachChild(router)
  }
  
  func attachCategoryColorModalVC() {
    if categoryColorModalRouting != nil { return }
    let router = categoryColorModalBuildable.build(withListener: interactor)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    categoryColorModalRouting = router
    attachChild(router)
  }
  
  func detachCategoryColorModalVC() {
    guard let router = categoryColorModalRouting else { return }
    viewControllable.dismiss(animated: false, completion: nil)
    categoryColorModalRouting = nil
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
