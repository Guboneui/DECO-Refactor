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
  
 
  func attachHome() {
    if homeRouting != nil { return }
    let router = homeBuildable.build(withListener: interactor)
    attachChild(router)
    self.homeRouting = router
    self.viewController.setChildVCLayout(childVC: router.viewControllable)
  }
  
  
  
//  func attachNewChildVC(with type: TabType) {
//    switch type {
//    case .Home:
//      self.attachHomeRIB()
//    case .Product:
//      self.attachProductRIB()
//    case .Bookmark:
//      self.attachBookmarkRIB()
//    case .Profile:
//      self.attachProfileRIB()
//    default: break
//    }
//  }
//
//  func detachPrevChildRib() {
//    self.detachHomeRIB()
//    self.detachProductRIB()
//    self.detachBookmarkRIB()
//    self.detachProfileRIB()
//  }
}

// MARK: - Private Method
extension MainRouter {
  private func attachHomeRIB() {
    if homeRouting != nil { return }
    let router = homeBuildable.build(withListener: interactor)
    attachChild(router)
    self.homeRouting = router
  }
  
  private func detachHomeRIB() {
    if let router = homeRouting {
      detachChild(router)
      self.homeRouting = nil
    }
  }
  
  private func attachProductRIB() {
    if productRouting != nil { return }
    let router = productBuildable.build(withListener: interactor)
    attachChild(router)
    self.productRouting = router
  }
  
  private func detachProductRIB() {
    if let router = productRouting {
      detachChild(router)
      self.productRouting = nil
    }
  }
  
  private func attachBookmarkRIB() {
    if bookmarkRouting != nil { return }
    let router = bookmarkBuildable.build(withListener: interactor)

    attachChild(router)
    self.bookmarkRouting = router
  }
  
  private func detachBookmarkRIB() {
    if let router = bookmarkRouting {
      detachChild(router)
      self.bookmarkRouting = nil
    }
  }
  
  private func attachProfileRIB() {
    if profileRouting != nil { return }
    let router = profileBuildable.build(withListener: interactor)
    attachChild(router)
    self.profileRouting = router
  }
  
  private func detachProfileRIB() {
    if let router = profileRouting {
      detachChild(router)
      self.profileRouting = nil
    }
  }

//  func test() {
//    if productRouting != nil { return }
//    let router = productBuildable.build(withListener: interactor)
//    //self.viewControllable.prese(router.viewControllable, animated: true)
//    self.viewControllable.present(router.viewControllable, animated: true, completion: nil)
//    attachChild(router)
//    self.productRouting = router
//  }
}
