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
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let boardRepository: BoardRepository
  private let userManager: MutableUserManagerStream
  private let postingCategoryFilter: MutableSelectedPostingFilterStream
  
  var popularBoardList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  private var selectedBoardId: [Int] = []
  private var selectedStyleId: [Int] = []
  
  init(
    presenter: PopularBoardPresentable,
    boardRepository: BoardRepository,
    userManager: MutableUserManagerStream,
    postingCategoryFilter: MutableSelectedPostingFilterStream
  ) {
    self.boardRepository = boardRepository
    self.userManager = userManager
    self.postingCategoryFilter = postingCategoryFilter
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    postingCategoryFilter.selectedFilter
      .share()
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let boardId: [Int] = filter.selectedBoardCategory.map{$0.id}
        let styleId: [Int] = filter.selectedStyleCategory.map{$0.id}
        self.selectedBoardId = boardId
        self.selectedStyleId = styleId
        self.fetchPopularBoardListNewCategory(boardId: boardId, styleId: styleId)
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchPopularBoardListNewCategory(boardId: [Int], styleId: [Int]) {
    Task.detached { [weak self] in
      guard let self else { return }
      self.popularBoardList.accept([])
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: Int.max,
          listType: BoardType.LIKE.rawValue,
          keyword: "",
          styleIds: styleId,
          colorIds: [],
          boardCategoryIds: boardId,
          userId: self.userManager.userID
        )
      ) {
        self.popularBoardList.accept(boardList)
      }
    }
  }
  
  func fetchPopularBoardList(at createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: createdAt,
          listType: BoardType.LIKE.rawValue,
          keyword: "",
          styleIds: self.selectedStyleId,
          colorIds: [],
          boardCategoryIds: self.selectedBoardId,
          userId: self.userManager.userID
        )
      ), !boardList.isEmpty {
        let prevList = self.popularBoardList.value
        self.popularBoardList.accept(prevList + boardList)
      }
    }
  }
}
