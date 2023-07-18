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
  func setChildVCLayout(childVC: ViewControllable)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
  
  private let homeBuildable: HomeBuildable
  private var homeRouting: Routing?
  
  private let productBuildable: ProductBuildable
  private var productRouting: Routing?
  
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
  }
  
  override func didLoad() {
    super.didLoad()
    attachHomeRIB()
  }
  
  func attachChildVCRib(with type: TabType) {
    switch type {
    case .Home:
      detachProductRIB()
      detachBookmarkRIB()
      detachProfileRIB()
      attachHomeRIB()
    case .Product:
      detachHomeRIB()
      detachBookmarkRIB()
      detachProfileRIB()
      attachProductRIB()
    case .Upload: break
    case .Bookmark:
      detachHomeRIB()
      detachProductRIB()
      detachProfileRIB()
      attachBookmarkRIB()
    case .Profile:
      detachHomeRIB()
      detachProductRIB()
      detachBookmarkRIB()
      attachProfileRIB()
    }
  }
  
  func detachChildVCRib() {
    self.detachAllChildRIB()
  }
  
  private func detachAllChildRIB() {
    self.detachHomeRIB()
    self.detachProductRIB()
    self.detachBookmarkRIB()
    self.detachProfileRIB()
  }
}

// MARK: - Private Method
extension MainRouter {
  private func attachHomeRIB() {
    if homeRouting != nil { return }
    let router = homeBuildable.build(withListener: interactor)
    self.homeRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
    attachChild(router)
  }
  
  private func detachHomeRIB() {
    if let router = homeRouting {
      self.homeRouting = nil
      detachChild(router)
    }
  }
  
  private func attachProductRIB() {
    if productRouting != nil { return }
    let router = productBuildable.build(withListener: interactor)
    self.productRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
    attachChild(router)
  }
  
  private func detachProductRIB() {
    if let router = productRouting {
      self.productRouting = nil
      detachChild(router)
    }
  }
  
  private func attachBookmarkRIB() {
    if bookmarkRouting != nil { return }
    let router = bookmarkBuildable.build(withListener: interactor)
    self.bookmarkRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
    attachChild(router)
  }
  
  private func detachBookmarkRIB() {
    if let router = bookmarkRouting {
      self.bookmarkRouting = nil
      detachChild(router)
    }
  }
  
  private func attachProfileRIB() {
    if profileRouting != nil { return }
    let router = profileBuildable.build(withListener: interactor)
    self.profileRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
    attachChild(router)
  }
  
  private func detachProfileRIB() {
    if let router = profileRouting {
      self.profileRouting = nil
      detachChild(router)
    }
  }
}
