//
//  SearchResultRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Util
import Entity
import ProductDetail

import RIBs

protocol SearchResultInteractable:
  Interactable,
  SearchPhotoListener,
  SearchProductListener,
  SearchBrandListener,
  SearchUserListener,
  ProductDetailListener
{
  var router: SearchResultRouting? { get set }
  var listener: SearchResultListener? { get set }
  
  var searchPhotoViewControllerable: ViewControllable? { get set }
  var searchProductViewControllerable: ViewControllable? { get set }
  var searchBrandViewControllerable: ViewControllable? { get set }
  var searchUserViewControllerable: ViewControllable? { get set }
}

protocol SearchResultViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchResultRouter: ViewableRouter<SearchResultInteractable, SearchResultViewControllable>, SearchResultRouting {
  
  private let searchPhotoBuildable: SearchPhotoBuildable
  private var searchPhotoRouting: Routing?
  
  private let searchProductBuildable: SearchProductBuildable
  private var searchProductRouting: Routing?
  
  private let searchBrandBuildable: SearchBrandBuildable
  private var searchBrandRouting: Routing?
  
  private let searchUserBuildable: SearchUserBuildable
  private var searchUserRouting: Routing?
  
  private let productDetailBuildable: ProductDetailBuildable
  private var productDetailRouting: Routing?
  
  
  init(
    interactor: SearchResultInteractable,
    viewController: SearchResultViewControllable,
    searchPhotoBuildable: SearchPhotoBuildable,
    searchProductBuildable: SearchProductBuildable,
    searchBrandBuildable: SearchBrandBuildable,
    searchUserBuildable: SearchUserBuildable,
    productDetailBuildable: ProductDetailBuildable
  ) {
    self.searchPhotoBuildable = searchPhotoBuildable
    self.searchProductBuildable = searchProductBuildable
    self.searchBrandBuildable = searchBrandBuildable
    self.searchUserBuildable = searchUserBuildable
    self.productDetailBuildable = productDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    
    self.attachSearchPhotoRIB()
    self.attachSearchProductRIB()
    self.attachSearchBrandRIB()
    self.attachSearchUserRIB()
  }
  
  private func attachSearchPhotoRIB() {
    if searchPhotoRouting != nil { return }
    let router = searchPhotoBuildable.build(withListener: interactor)
    self.interactor.searchPhotoViewControllerable = router.viewControllable
    self.searchPhotoRouting = router
    attachChild(router)
  }
  
  private func attachSearchProductRIB() {
    if searchProductRouting != nil { return }
    let router = searchProductBuildable.build(withListener: interactor)
    self.interactor.searchProductViewControllerable = router.viewControllable
    self.searchProductRouting = router
    attachChild(router)
  }
  
  private func attachSearchBrandRIB() {
    if searchBrandRouting != nil { return }
    let router = searchBrandBuildable.build(withListener: interactor)
    self.interactor.searchBrandViewControllerable = router.viewControllable
    self.searchBrandRouting = router
    attachChild(router)
  }
  
  private func attachSearchUserRIB() {
    if searchUserRouting != nil { return }
    let router = searchUserBuildable.build(withListener: interactor)
    self.interactor.searchUserViewControllerable = router.viewControllable
    self.searchUserRouting = router
    attachChild(router)
  }
  
  func attachProductDetailVC(with productInfo: Entity.ProductDTO) {
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
