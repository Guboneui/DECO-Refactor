//
//  HomeRouter.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs

protocol HomeInteractable: Interactable {
  var router: HomeRouting? { get set }
  var listener: HomeListener? { get set }
}

public protocol HomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
  
  override init(
    interactor: HomeInteractable,
    viewController: HomeViewControllable
  ) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
