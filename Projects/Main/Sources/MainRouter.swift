//
//  MainRouter.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs
import Home
import Product
import Bookmark
import Profile
import UIKit
import Util


public protocol MainInteractable:
  Interactable,
  HomeListener,
  ProductListener,
  BookmarkListener,
  ProfileListener

{
  var router: MainRouting? { get set }
  var listener: MainListener? { get set }
}

public protocol MainViewControllable: ViewControllable {
  var tabbarViewControllers: [TabType:ViewControllable] { get set }
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
  
  private let homeBuildable: HomeBuildable
  private var homeRouting: Routing?
  
  private let productBuildable: ProductBuildable
  private var productRouting: Routing?
  
//  private let uploadBuildable: UploadBuildable
//  private var uploadRouting: Routing?
//
  private let bookmarkBuildable: BookmarkBuildable
  private var bookmarkRouting: Routing?
  
  private let profileBuildable: ProfileBuildable
  private var profileRouting: Routing?
  
  init(
    interactor: MainInteractable,
    viewController: MainViewControllable,
    homeBuildable: HomeBuildable,
    productBuildable: ProductBuildable,
    bookmarkBuildable: BookmarkBuildable,
    profileBuildable: ProfileBuildable
  ) {
    self.homeBuildable = homeBuildable
    self.productBuildable = productBuildable
    self.bookmarkBuildable = bookmarkBuildable
    self.profileBuildable = profileBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    self.attachTabbarRIBs()
  }
}

// MARK: - Private Method
extension MainRouter {
  private func attachTabbarRIBs() {
    // HOME
    if homeRouting != nil { return }
    let homeRouter = homeBuildable.build(withListener: interactor)
    self.homeRouting = homeRouter
    attachChild(homeRouter)
    
    // PRODUCT
    if productRouting != nil { return }
    let productRouter = productBuildable.build(withListener: interactor)
    self.productRouting = productRouter
    attachChild(productRouter)
    
    // BOOKMARK
    if bookmarkRouting != nil { return }
    let bookmarkRouter = bookmarkBuildable.build(withListener: interactor)
    self.bookmarkRouting = bookmarkRouter
    attachChild(bookmarkRouter)
    
    // PROFILE
    if profileRouting != nil { return }
    let profileRouter = profileBuildable.build(withListener: interactor)
    self.profileRouting = profileRouter
    attachChild(profileRouter)
  
    let tabbarViewControllers: [TabType:ViewControllable] = [
      TabType.Home: homeRouter.viewControllable,
      TabType.Product: productRouter.viewControllable,
      TabType.Bookmark: bookmarkRouter.viewControllable,
      TabType.Profile: profileRouter.viewControllable
    ]
    
    viewController.tabbarViewControllers = tabbarViewControllers
  }
  
  private func detachHomeRIB() {
    if let router = homeRouting {
      self.homeRouting = nil
      detachChild(router)
    }
  }
  
  
  private func detachProductRIB() {
    if let router = productRouting {
      self.productRouting = nil
      detachChild(router)
    }
  }
  
  private func detachBookmarkRIB() {
    if let router = bookmarkRouting {
      self.bookmarkRouting = nil
      detachChild(router)
    }
  }
  
  private func detachProfileRIB() {
    if let router = profileRouting {
      self.profileRouting = nil
      detachChild(router)
    }
  }
}
