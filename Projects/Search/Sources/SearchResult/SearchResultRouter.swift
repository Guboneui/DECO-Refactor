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
import RxRelay

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
}

protocol SearchResultViewControllable: ViewControllable {
  var searchResultControllers: BehaviorRelay<[ViewControllable]> { get set }
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
    self.attachSearchResultChildRIB()
  }
  
  deinit {
    self.detachSearchResultChildRIB()
  }
  
  private func attachSearchResultChildRIB() {
    if searchPhotoRouting != nil { return }
    let searchPhotoRouter = searchPhotoBuildable.build(withListener: interactor)
    
    if searchProductRouting != nil { return }
    let searchProductRouter = searchProductBuildable.build(withListener: interactor)
    
    if searchBrandRouting != nil { return }
    let searchBrandRouter = searchBrandBuildable.build(withListener: interactor)
    
    if searchUserRouting != nil { return }
    let searchUserRouter = searchUserBuildable.build(withListener: interactor)
    
    self.searchPhotoRouting = searchPhotoRouter
    self.searchProductRouting = searchProductRouter
    self.searchBrandRouting = searchBrandRouter
    self.searchUserRouting = searchUserRouter
    
    attachChild(searchPhotoRouter)
    attachChild(searchProductRouter)
    attachChild(searchBrandRouter)
    attachChild(searchUserRouter)
    
    viewController.searchResultControllers.accept([
      searchPhotoRouter.viewControllable,
      searchProductRouter.viewControllable,
      searchBrandRouter.viewControllable,
      searchUserRouter.viewControllable
    ])
  }
  
  private func detachSearchResultChildRIB() {
    guard let searchPhotoRouter = searchPhotoRouting,
          let searchProductRouter = searchProductRouting,
          let searchBrandRouter = searchBrandRouting,
          let searchUserRouter = searchUserRouting else { return }
    
    self.searchPhotoRouting = nil
    self.searchProductRouting = nil
    self.searchBrandRouting = nil
    self.searchUserRouting = nil
    
    self.detachChild(searchPhotoRouter)
    self.detachChild(searchProductRouter)
    self.detachChild(searchBrandRouter)
    self.detachChild(searchUserRouter)
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
