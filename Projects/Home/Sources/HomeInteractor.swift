//
//  HomeInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs
import RxSwift

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
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
