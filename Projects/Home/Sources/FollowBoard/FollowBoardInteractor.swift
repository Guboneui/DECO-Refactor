//
//  FollowBoardInteractor.swift
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

protocol FollowBoardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FollowBoardPresentable: Presentable {
  var listener: FollowBoardPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FollowBoardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FollowBoardInteractor: PresentableInteractor<FollowBoardPresentable>, FollowBoardInteractable, FollowBoardPresentableListener {
  
  weak var router: FollowBoardRouting?
  weak var listener: FollowBoardListener?
  
  private let boardRepository: BoardRepository
  private let userManager: MutableUserManagerStream
  
  var followBoardList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: FollowBoardPresentable,
    boardRepository: BoardRepository,
    userManager: MutableUserManagerStream
  ) {
    self.boardRepository = boardRepository
    self.userManager = userManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    fetchFollowBoardList(at: Int.max)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchFollowBoardList(at createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: createdAt,
          listType: BoardType.FOLLOW.rawValue,
          keyword: "",
          styleIds: [],
          colorIds: [],
          boardCategoryIds: [],
          userId: self.userManager.userID
        )
      ), !boardList.isEmpty {
        let prevList = self.followBoardList.value
        self.followBoardList.accept(prevList + boardList)
      }
    }
  }
}
