//
//  HomeRouter.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import Util
import Search

import RIBs
import RxRelay

protocol HomeInteractable:
  Interactable,
  LatestBoardListener,
  PopularBoardListener,
  FollowBoardListener,
  SearchListener
{
  var router: HomeRouting? { get set }
  var listener: HomeListener? { get set }
}

public protocol HomeViewControllable: ViewControllable {
  var homeBoardControllers: BehaviorRelay<[ViewControllable]> { get set }
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
  
  private let latestBoardBuildable: LatestBoardBuildable
  private var latestBoardRouting: Routing?
  
  private let popularBoardBuildable: PopularBoardBuildable
  private var popularBoardRouting: Routing?
  
  private let followBoardBuildable: FollowBoardBuildable
  private var followBoardRouting: Routing?
  
  private let searchBuildable: SearchBuildable
  private var searchRouting: Routing?
  
  init(
    interactor: HomeInteractable,
    viewController: HomeViewControllable,
    latestBoardBuildable: LatestBoardBuildable,
    popularBoardBuildable: PopularBoardBuildable,
    followBoardBuildable: FollowBoardBuildable,
    searchBuildable: SearchBuildable
  ) {
    self.latestBoardBuildable = latestBoardBuildable
    self.popularBoardBuildable = popularBoardBuildable
    self.followBoardBuildable = followBoardBuildable
    self.searchBuildable = searchBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
    self.attachHomeBoardRIB()
  }
  
  deinit {
    self.detachHomeBoardRIB()
  }
  
  private func attachHomeBoardRIB() {
    if latestBoardRouting != nil { return }
    let latestBoardRouter = latestBoardBuildable.build(withListener: interactor)
    
    if popularBoardRouting != nil { return }
    let popularBoardRouter = popularBoardBuildable.build(withListener: interactor)
    
    if followBoardRouting != nil { return }
    let followBoardRouter = followBoardBuildable.build(withListener: interactor)
    
    self.latestBoardRouting = latestBoardRouter
    self.popularBoardRouting = popularBoardRouter
    self.followBoardRouting = followBoardRouter
    attachChild(latestBoardRouter)
    attachChild(popularBoardRouter)
    attachChild(followBoardRouter)
    
    viewController.homeBoardControllers.accept([
      latestBoardRouter.viewControllable,
      popularBoardRouter.viewControllable,
      followBoardRouter.viewControllable
    ])
  }
  
  private func detachHomeBoardRIB() {
    guard let latestBoardRouter = latestBoardRouting else { return }
    guard let popularBoardRouter = popularBoardRouting else { return }
    guard let followBoardRouter = followBoardRouting else { return }
    
    self.latestBoardRouting = nil
    self.popularBoardRouting = nil
    self.followBoardRouting = nil
    
    self.detachChild(latestBoardRouter)
    self.detachChild(popularBoardRouter)
    self.detachChild(followBoardRouter)
  }
  
  func attachSearchVC() {
    if searchRouting != nil { return }
    let router = searchBuildable.build(withListener: interactor)
    self.searchRouting = router
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
  }
  
  func detachSearchVC(with popType: PopType) {
    guard let router = searchRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.searchRouting = nil
    self.detachChild(router)
  }
}
