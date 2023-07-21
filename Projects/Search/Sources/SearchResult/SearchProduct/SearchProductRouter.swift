//
//  SearchProductRouter.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchProductInteractable:
  Interactable,
  SearchProductFilterListener
{
  var router: SearchProductRouting? { get set }
  var listener: SearchProductListener? { get set }
}

protocol SearchProductViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SearchProductRouter: ViewableRouter<SearchProductInteractable, SearchProductViewControllable>, SearchProductRouting {
  
  private let searchProductFilterBuildable: SearchProductFilterBuildable
  private var searchProductFilterRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: SearchProductInteractable,
    viewController: SearchProductViewControllable,
    searchProductFilterBuildable: SearchProductFilterBuildable
  ) {
    self.searchProductFilterBuildable = searchProductFilterBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachFilterModalVC() {
    if searchProductFilterRouting != nil { return }
    let router = searchProductFilterBuildable.build(withListener: interactor)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    searchProductFilterRouting = router
    attachChild(router)
  }
  
  func detachFilterModalVC() {
    guard let router = searchProductFilterRouting else { return }
    viewControllable.dismiss(animated: false, completion: nil)
    searchProductFilterRouting = nil
    detachChild(router)
  }
}
