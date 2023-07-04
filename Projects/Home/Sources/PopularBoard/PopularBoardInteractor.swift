//
//  PopularBoardInteractor.swift
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

protocol PopularBoardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PopularBoardPresentable: Presentable {
  var listener: PopularBoardPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PopularBoardListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PopularBoardInteractor: PresentableInteractor<PopularBoardPresentable>, PopularBoardInteractable, PopularBoardPresentableListener {
  
  weak var router: PopularBoardRouting?
  weak var listener: PopularBoardListener?
  
  private let boardRepository: BoardRepository
  private let userManager: MutableUserManagerStream
  
  var popularBoardList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: PopularBoardPresentable,
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
    fetchPopularBoardList(at: Int.max)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchPopularBoardList(at createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: createdAt,
          listType: BoardType.LIKE.rawValue,
          keyword: "",
          styleIds: [],
          colorIds: [],
          boardCategoryIds: [],
          userId: self.userManager.userID
        )
      ), !boardList.isEmpty {
        let prevList = self.popularBoardList.value
        self.popularBoardList.accept(prevList + boardList)
      }
    }
  }
}
