//
//  HomeRouter.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import Util
import Search

import RIBs

protocol HomeInteractable:
  Interactable,
  LatestBoardListener,
  PopularBoardListener,
  FollowBoardListener,
  SearchListener
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
    self.interactor.latestBoardViewControllerable = router.viewControllable
    self.latestBoardRouting = router
    attachChild(router)
  }
  
  private func detachLatestBoardRIB() {
    guard let router = latestBoardRouting else { return }
    self.latestBoardRouting = nil
    self.detachChild(router)
  }
  
  private func attachPopularBoardRIB() {
    if popularBoardRouting != nil { return }
    let router = popularBoardBuildable.build(withListener: interactor)
    self.interactor.popularBoardViewControllerable = router.viewControllable
    self.popularBoardRouting = router
    attachChild(router)
  }
  
  private func detachPopularBoardRIB() {
    guard let router = popularBoardRouting else { return }
    self.popularBoardRouting = nil
    self.detachChild(router)
  }
  
  private func attachFollowBoardRIB() {
    if followBoardRouting != nil { return }
    let router = followBoardBuildable.build(withListener: interactor)
    self.interactor.followBoardViewControllerable = router.viewControllable
    self.followBoardRouting = router
    attachChild(router)
  }
  
  private func detachFollowBoardRIB() {
    guard let router = followBoardRouting else { return }
    followBoardRouting = nil
    detachChild(router)
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
