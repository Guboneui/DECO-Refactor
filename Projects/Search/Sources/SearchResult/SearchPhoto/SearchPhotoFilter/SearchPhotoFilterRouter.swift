//
//  SearchPhotoFilterRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/16.
//

import RIBs

protocol SearchPhotoFilterInteractable: Interactable {
  var router: SearchPhotoFilterRouting? { get set }
  var listener: SearchPhotoFilterListener? { get set }
}

protocol SearchPhotoFilterViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchPhotoFilterRouter: ViewableRouter<SearchPhotoFilterInteractable, SearchPhotoFilterViewControllable>, SearchPhotoFilterRouting {
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: SearchPhotoFilterInteractable, viewController: SearchPhotoFilterViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
