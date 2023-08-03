//
//  BookmarkRouter.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import RIBs
import RxRelay

protocol BookmarkInteractable:
  Interactable,
  PhotoBookmarkListener,
  ProductBookmarkListener
{
  var router: BookmarkRouting? { get set }
  var listener: BookmarkListener? { get set }
}

public protocol BookmarkViewControllable: ViewControllable {
  var bookmarkControllers: BehaviorRelay<[ViewControllable]> { get set }
}

final class BookmarkRouter: ViewableRouter<BookmarkInteractable, BookmarkViewControllable>, BookmarkRouting {

  private let photoBookmarkBuildable: PhotoBookmarkBuildable
  private var photoBookmarkRouting: Routing?
  
  private let productBookmarkBuildable: ProductBookmarkBuildable
  private var productBookmarkRouting: Routing?
  
  init(
    interactor: BookmarkInteractable,
    viewController: BookmarkViewControllable,
    photoBookmarkBuildable: PhotoBookmarkBuildable,
    productBookmarkBuildable: ProductBookmarkBuildable
  ) {
    self.photoBookmarkBuildable = photoBookmarkBuildable
    self.productBookmarkBuildable = productBookmarkBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    self.attachBookmarkChildRIB()
  }
  
  deinit {
    self.detachBookmarkChildRIB()
  }
  
  private func attachBookmarkChildRIB() {
    if photoBookmarkRouting != nil { return }
    let photoBookmarkRouter = photoBookmarkBuildable.build(withListener: interactor)
    
    if productBookmarkRouting != nil { return }
    let productBookmarkRouter = productBookmarkBuildable.build(withListener: interactor)
    
    self.photoBookmarkRouting = photoBookmarkRouter
    self.productBookmarkRouting = productBookmarkRouter
    attachChild(photoBookmarkRouter)
    attachChild(productBookmarkRouter)
    
    let photoBookmarkViewController = photoBookmarkRouter.viewControllable
    let productBookmarkViewController = productBookmarkRouter.viewControllable
    
    viewController.bookmarkControllers.accept([photoBookmarkViewController, productBookmarkViewController])
  }
  
  private func detachBookmarkChildRIB() {
    guard let photoBookmarkRouter = photoBookmarkRouting else { return }
    guard let productBookmarkRouter = productBookmarkRouting else { return }
    
    self.photoBookmarkRouting = nil
    self.productBookmarkRouting = nil
    
    self.detachChild(photoBookmarkRouter)
    self.detachChild(productBookmarkRouter)
  }
}
