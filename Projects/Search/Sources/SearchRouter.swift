//
//  SearchRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import Util

import RIBs

protocol SearchInteractable:
  Interactable,
  SearchResultListener
{
  var router: SearchRouting? { get set }
  var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
  
  private let searchResultBuildable: SearchResultBuildable
  private var searchResultRouting: Routing?
  
  init(
    interactor: SearchInteractable,
    viewController: SearchViewControllable,
    searchResultBuildable: SearchResultBuildable
  ) {
    self.searchResultBuildable = searchResultBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachSearchResultVC(with searchText: String) {
    if searchResultRouting != nil { return }
    let router = searchResultBuildable.build(withListener: interactor, searchText: searchText)
    attachChild(router)
    self.searchResultRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
  }
  
  func detachSearchResultVC(with popType: PopType) {
    guard let router = searchResultRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.detachChild(router)
    self.searchResultRouting = nil
  }
}
