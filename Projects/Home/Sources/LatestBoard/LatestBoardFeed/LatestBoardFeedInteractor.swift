//
//  LatestBoardFeedInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import Util
import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol LatestBoardFeedRouting: ViewableRouting {
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO)
  func detachTargetUserProfileVC(with popType: PopType)
}

protocol LatestBoardFeedPresentable: Presentable {
  var listener: LatestBoardFeedPresentableListener? { get set }
  @MainActor func showToast(status: Bool)
  func showAlert(isMine: Bool)
  func moveToStartIndex(at index: Int)
}

protocol LatestBoardFeedListener: AnyObject {
  func popLatestBoardFeedVC(with popType: PopType)
}

final class LatestBoardFeedInteractor: PresentableInteractor<LatestBoardFeedPresentable>, LatestBoardFeedInteractable, LatestBoardFeedPresentableListener {
  
  weak var router: LatestBoardFeedRouting?
  weak var listener: LatestBoardFeedListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  var latestBoardList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  private let boardListStream: MutableBoardStream
  private let userManager: MutableUserManagerStream
  private let bookmarkRepository: BookmarkRepository
  private let boardRepository: BoardRepository
  private let postingCategoryFilter: MutableSelectedPostingFilterStream
  private let feedStartIndex: Int
  
  private var selectedBoardId: [Int] = []
  private var selectedStyleId: [Int] = []
  
  init(
    presenter: LatestBoardFeedPresentable,
    boardListStream: MutableBoardStream,
    userManager: MutableUserManagerStream,
    bookmarkRepository: BookmarkRepository,
    boardRepository: BoardRepository,
    postingCategoryFilter: MutableSelectedPostingFilterStream,
    feedStartIndex: Int
  ) {
    self.boardListStream = boardListStream
    self.userManager = userManager
    self.bookmarkRepository = bookmarkRepository
    self.boardRepository = boardRepository
    self.postingCategoryFilter = postingCategoryFilter
    self.feedStartIndex = feedStartIndex
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.setupBindings()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popLatestBoardFeedVC(with popType: PopType) {
    listener?.popLatestBoardFeedVC(with: popType)
  }
  
  private func setupBindings() {
    boardListStream.boardList
      .subscribe(onNext: { [weak self] list in
        self?.latestBoardList.accept(list)
      }).disposed(by: disposeBag)
    
    postingCategoryFilter.selectedFilter
      .take(1) // 사이드 이팩트 방지하기 위해서 1회만 호출
      .share()
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let boardId: [Int] = filter.selectedBoardCategory.map{$0.id}
        let styleId: [Int] = filter.selectedStyleCategory.map{$0.id}
        self.selectedBoardId = boardId
        self.selectedStyleId = styleId
      }).disposed(by: disposeBag)
    
    
    Observable.just(feedStartIndex)
      .take(1)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] startIndex in
        guard let self else { return }
        self.presenter.moveToStartIndex(at: startIndex)
      }).disposed(by: disposeBag)
  }
  
  func fetchBoardBookmark(at index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let currentBoard: PostingDTO = self.latestBoardList.value[index]
      guard let scrapStatus = currentBoard.scrap,
            let boardID = currentBoard.id else { return }
      if scrapStatus == true {
        _ = await self.bookmarkRepository.deleteBookmark(
          productId: 0,
          boardId: boardID,
          userId: self.userManager.userID
        )
      } else {
        _ = await self.bookmarkRepository.addBookmark(
          productId: 0,
          boardId: boardID,
          userId: self.userManager.userID
        )
      }
      await self.changedBookmarkStatus(at: index, status: scrapStatus)
      await self.presenter.showToast(status: scrapStatus)
    }
  }
  
  private func changedBookmarkStatus(at index: Int, status: Bool) async {
    var boardData: [PostingDTO] = self.latestBoardList.value
    var currentBoard: PostingDTO = boardData[index]
    currentBoard.scrap = !status
    boardData[index] = currentBoard
    boardListStream.updateBoardList(with: boardData)
  }
  
  func fetchBoardLike(at index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let currentBoard: PostingDTO = self.latestBoardList.value[index]
      guard let likeStatus = currentBoard.like,
            let boardID = currentBoard.id else { return }
      
      if likeStatus == true {
        _ = await self.boardRepository.boardDisLike(boardID: boardID, userID: self.userManager.userID)
      } else {
        _ = await self.boardRepository.boardLike(boardID: boardID, userID: self.userManager.userID)
      }
      
      if let updatedBoard = await self.boardRepository.boardInfo(boardID: boardID, userID: self.userManager.userID) {
        await self.updatedBoardList(at: index, updatedBoard: updatedBoard)
      }
    }
  }
  
  private func updatedBoardList(at index: Int, updatedBoard: PostingDTO) async {
    var boardData: [PostingDTO] = self.latestBoardList.value
    boardData[index] = updatedBoard
    boardListStream.updateBoardList(with: boardData)
  }
  
  func checkCurrentBoardUser(at index: Int) {
    let currentBoard: PostingDTO = self.latestBoardList.value[index]
    guard let boardUserID = currentBoard.userId else { return }
    let currentUserID = userManager.userID
    presenter.showAlert(isMine: boardUserID == currentUserID)
  }
  
  func pushTargetUserProfileVC(at index: Int) {
    let currentBoard: PostingDTO = self.latestBoardList.value[index]
    guard let boardUserID = currentBoard.userId,
          let profileURL = currentBoard.profileUrl,
          let followStatus = currentBoard.follow,
          let nickName = currentBoard.userName,
          let profileName = currentBoard.profileName else { return }
    
    let targetUserInfo: UserDTO = UserDTO(
      profileUrl: profileURL,
      followStatus: followStatus,
      nickName: nickName,
      userId: boardUserID,
      profileName: profileName
    )
    router?.attachTargetUserProfileVC(with: targetUserInfo)
  }
  
  func popTargetUserProfileVC(with popType: Util.PopType) {
    router?.detachTargetUserProfileVC(with: popType)
  }
  
  func fetchLatestBoardList(lastIndex index: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let createdAt: Int = self.latestBoardList.value[index].createdAt ?? Int.max
      if let boardList = await self.boardRepository.boardList(
        param: BoardRequestDTO(
          offset: createdAt,
          listType: BoardType.LATEST.rawValue,
          keyword: "",
          styleIds: self.selectedStyleId,
          colorIds: [],
          boardCategoryIds: self.selectedBoardId,
          userId: self.userManager.userID
        )
      ), !boardList.isEmpty {
        let prevList = self.latestBoardList.value
        self.boardListStream.updateBoardList(with: prevList + boardList)
      }
    }
  }
}
