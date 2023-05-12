//
//  MainInteractor.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs
import RxSwift
import Home
import Product
import Bookmark
import Profile
import Foundation

public enum TabType {
  case Home
  case Product
  case Upload
  case Bookmark
  case Profile
}

public protocol MainRouting: ViewableRouting {
  func attachNewChildVC(with type: TabType)
  func detachPrevChildRib()
}

protocol MainPresentable: Presentable {
  var listener: MainPresentableListener? { get set }
  
  //func addNewChildVC(with type: TabType, vc: ViewControllable)
  func startWithHomeVC(vc: ViewControllable)
}

public protocol MainListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
  
  
  
  weak var router: MainRouting?
  weak var listener: MainListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: MainPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    self.presenter.startWithHomeVC(vc: HomeViewController())
    self.router?.attachNewChildVC(with: .Home)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  
  // MARK: - MainPresentableListener
  func showNewChildVC(with type: TabType) {
    switch type {
    case .Home: presenter.startWithHomeVC(vc: HomeViewController())
    case .Product: presenter.startWithHomeVC(vc: ProductViewController())
    case .Upload: break
    case .Bookmark: presenter.startWithHomeVC(vc: BookmarkViewController())
    case .Profile: presenter.startWithHomeVC(vc: ProductViewController())
    }
    
    router?.attachNewChildVC(with: type)
  }
  
  func hidePrevChildVC() {
    
  }
  
  func removeChildVCRib() {
    self.router?.detachPrevChildRib()
  }
}
