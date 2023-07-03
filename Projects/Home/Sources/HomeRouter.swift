//
//  HomeRouter.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs

protocol HomeInteractable:
  Interactable,
  LatestBoardListener,
  PopularBoardListener,
  FollowBoardListener
{
  var router: HomeRouting? { get set }
  var listener: HomeListener? { get set }
  
  var latestBoardViewControllerable: ViewControllable? { get set }
  var popularBoardViewControllerable: ViewControllable? { get set }
  var followBoardViewControllerable: ViewControllable? { get set }
}

public protocol HomeViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
  
  private let latestBoardBuildable: LatestBoardBuildable
  private var latestBoardRouting: Routing?
  
  private let popularBoardBuildable: PopularBoardBuildable
  private var popularBoardRouting: Routing?
  
  private let followBoardBuildable: FollowBoardBuildable
  private var followBoardRouting: Routing?
  
  init(
    interactor: HomeInteractable,
    viewController: HomeViewControllable,
    latestBoardBuildable: LatestBoardBuildable,
    popularBoardBuildable: PopularBoardBuildable,
    followBoardBuildable: FollowBoardBuildable
  ) {
    self.latestBoardBuildable = latestBoardBuildable
    self.popularBoardBuildable = popularBoardBuildable
    self.followBoardBuildable = followBoardBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    self.attachLatestBoardRIB()
    self.attachPopularBoardRIB()
    self.attachFollowBoardRIB()
  }
  
  deinit {
    self.detachLatestBoardRIB()
    self.detachPopularBoardRIB()
    self.detachFollowBoardRIB()
  }
  
  private func attachLatestBoardRIB() {
    if latestBoardRouting != nil { return }
    let router = latestBoardBuildable.build(withListener: interactor)
    attachChild(router)
    self.interactor.latestBoardViewControllerable = router.viewControllable
    self.latestBoardRouting = router
  }
  
  private func detachLatestBoardRIB() {
    guard let router = latestBoardRouting else { return }
    self.detachChild(router)
    self.latestBoardRouting = nil
  }
  
  private func attachPopularBoardRIB() {
    if popularBoardRouting != nil { return }
    let router = popularBoardBuildable.build(withListener: interactor)
    attachChild(router)
    self.interactor.popularBoardViewControllerable = router.viewControllable
    self.popularBoardRouting = router
  }
  
  private func detachPopularBoardRIB() {
    guard let router = popularBoardRouting else { return }
    self.detachChild(router)
    self.popularBoardRouting = nil
  }
  
  private func attachFollowBoardRIB() {
    if followBoardRouting != nil { return }
    let router = followBoardBuildable.build(withListener: interactor)
    attachChild(router)
    self.interactor.followBoardViewControllerable = router.viewControllable
    self.followBoardRouting = router
  }
  
  private func detachFollowBoardRIB() {
    guard let router = followBoardRouting else { return }
    detachChild(router)
    followBoardRouting = nil
  }
  
  
}
