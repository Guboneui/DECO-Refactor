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
  
  
  // TODO: Constructor inject child builder protocols to allow building children.
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
  
  private func attachPhotoBookmarkRIB() {
    if photoBookmarkRouting != nil { return }
    let router = photoBookmarkBuildable.build(withListener: interactor)
    attachChild(router)
    self.interactor.photoBookmarkViewControllerable = router.viewControllable
    self.photoBookmarkRouting = router

  }
  
  private func attachProductBookmarkRIB() {
    if productBookmarkRouting != nil { return }
    let router = productBookmarkBuildable.build(withListener: interactor)
    attachChild(router)
    self.interactor.productBookmarkViewControllerable = router.viewControllable
    self.productBookmarkRouting = router
    
  }
}

