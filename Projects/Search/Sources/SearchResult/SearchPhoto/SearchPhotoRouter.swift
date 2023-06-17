//
//  SearchPhotoRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchPhotoInteractable:
  Interactable,
  SearchPhotoFilterListener
{
  var router: SearchPhotoRouting? { get set }
  var listener: SearchPhotoListener? { get set }
}

protocol SearchPhotoViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchPhotoRouter: ViewableRouter<SearchPhotoInteractable, SearchPhotoViewControllable>, SearchPhotoRouting {
  
  private let searchPhotoFilterBuildable: SearchPhotoFilterBuildable
  private var searchPhotoFilterRouting: Routing?
  
  init(
    interactor: SearchPhotoInteractable,
    viewController: SearchPhotoViewControllable,
    searchPhotoFilterBuildable: SearchPhotoFilterBuildable
  ) {
    self.searchPhotoFilterBuildable = searchPhotoFilterBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachFilterModalVC() {
    if searchPhotoFilterRouting != nil { return }
    let router = searchPhotoFilterBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    searchPhotoFilterRouting = router
  }
  
  func detachFilterModalVC() {
    guard let router = searchPhotoFilterRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    searchPhotoFilterRouting = nil
  }
}
