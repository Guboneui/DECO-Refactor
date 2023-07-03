//
//  HomeInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs
import RxSwift
import RxRelay

import Entity
import Networking

public protocol HomeRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol HomePresentable: Presentable {
  var listener: HomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol HomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
  
  
  
  
  var latestBoardViewControllerable: RIBs.ViewControllable?
  var popularBoardViewControllerable: RIBs.ViewControllable?
  var followBoardViewControllerable: RIBs.ViewControllable?
  
  var boardVCs: BehaviorRelay<[ViewControllable]> = .init(value: [])
  
  weak var router: HomeRouting?
  weak var listener: HomeListener?
  
  private let boardRepository: BoardRepository
  
  init(
    presenter: HomePresentable,
    boardRepository: BoardRepository
  ) {
    self.boardRepository = boardRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    if let latestBoardViewControllerable,
       let popularBoardViewControllerable,
       let followBoardViewControllerable {
      self.boardVCs.accept([latestBoardViewControllerable, popularBoardViewControllerable, followBoardViewControllerable])
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
