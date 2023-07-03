//
//  LatestBoardInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol LatestBoardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LatestBoardPresentable: Presentable {
  var listener: LatestBoardPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LatestBoardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LatestBoardInteractor: PresentableInteractor<LatestBoardPresentable>, LatestBoardInteractable, LatestBoardPresentableListener {
  
  weak var router: LatestBoardRouting?
  weak var listener: LatestBoardListener?
  
  private let boardRepository: BoardRepository
  
  
  var latestBoardList: RxRelay.BehaviorRelay<[Entity.PostingDTO]> = .init(value: [])
  
  init(
    presenter: LatestBoardPresentable,
    boardRepository: BoardRepository
    
  ) {
    self.boardRepository = boardRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    fetchLatestBoardList(at: Int.max)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchLatestBoardList(at createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: createdAt,
          listType: BoardType.LATEST.rawValue,
          keyword: "",
          styleIds: [],
          colorIds: [],
          boardCategoryIds: [],
          userId: 72
        )
      ), !boardList.isEmpty {
        let prevList = self.latestBoardList.value
        self.latestBoardList.accept(prevList + boardList)
      }
    }
  }
}
