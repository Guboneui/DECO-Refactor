//
//  BookmarkRouter.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import RIBs

protocol BookmarkInteractable:
  Interactable,
  PhotoBookmarkListener,
  ProductBookmarkListener
{
  var router: BookmarkRouting? { get set }
  var listener: BookmarkListener? { get set }
  
  var photoBookmarkViewControllerable: ViewControllable? { get set }
  var productBookmarkViewControllerable: ViewControllable? { get set }
}

public protocol BookmarkViewControllable: ViewControllable {
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
    self.attachPhotoBookmarkRIB()
    self.attachProductBookmarkRIB()
  }
  
  deinit {
    self.detachPhotoBookmarkRIB()
    self.detachProductBookmarkRIB()
  }
  
  private func attachPhotoBookmarkRIB() {
    if photoBookmarkRouting != nil { return }
    let router = photoBookmarkBuildable.build(withListener: interactor)
    self.interactor.photoBookmarkViewControllerable = router.viewControllable
    self.photoBookmarkRouting = router
    attachChild(router)
  }
  
  private func detachPhotoBookmarkRIB() {
    guard let router = photoBookmarkRouting else { return }
    self.photoBookmarkRouting = nil
    self.detachChild(router)
  }
  
  private func attachProductBookmarkRIB() {
    if productBookmarkRouting != nil { return }
    let router = productBookmarkBuildable.build(withListener: interactor)
    self.interactor.productBookmarkViewControllerable = router.viewControllable
    self.productBookmarkRouting = router
    attachChild(router)
  }
  
  private func detachProductBookmarkRIB() {
    guard let router = productBookmarkRouting else { return }
    self.productBookmarkRouting = nil
    self.detachChild(router)
  }
}
