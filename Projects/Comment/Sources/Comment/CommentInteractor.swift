//
//  CommentInteractor.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import User
import Util
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol CommentRouting: ViewableRouting {
  func attachCommentDetailRIB(boardID: Int, parentComment: CommentDTO, commentParentID: Int)
  func detachCommentDetailRIB(with popType: PopType)
}

protocol CommentPresentable: Presentable {
  var listener: CommentPresentableListener? { get set }
}

protocol CommentListener: AnyObject {
  func didTapCloseButton()
}

final class CommentInteractor: PresentableInteractor<CommentPresentable>, CommentInteractable, CommentPresentableListener {
  
  weak var router: CommentRouting?
  weak var listener: CommentListener?
  
  private let boardID: Int
  private let userManager: MutableUserManagerStream
  private let boardRepository: BoardRepository
  
  var commentList: BehaviorRelay<[CommentDTO]> = .init(value: [])
  
  init(
    presenter: CommentPresentable,
    boardID: Int,
    userManager: MutableUserManagerStream,
    boardRepository: BoardRepository
  ) {
    self.boardID = boardID
    self.userManager = userManager
    self.boardRepository = boardRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchBoardCommentList()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchBoardCommentList() {
    Task.detached { [weak self] in
      guard let self else { return }
      let list = await self.boardRepository.boardCommentList(
        createdAt: Int.max,
        parentCommentID: 0,
        userID: self.userManager.userID,
        boardID: self.boardID
      )
      self.commentList.accept(list ?? [])
    }
  }
  
  func fetchCommentListNextPage(at createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let list = await self.boardRepository.boardCommentList(
        createdAt: createdAt,
        parentCommentID: 0,
        userID: self.userManager.userID,
        boardID: self.boardID
      ), !list.isEmpty {
        let prevList = self.commentList.value
        self.commentList.accept(prevList + list)
      }
    }
  }
  
  func pushCommentDetailVC(at index: Int) {
    let parentID: Int = commentList.value[index].postingReply.id
    let commentInfo: CommentDTO = commentList.value[index]
    self.router?.attachCommentDetailRIB(
      boardID: boardID,
      parentComment: commentInfo,
      commentParentID: parentID
    )
  }
  
  func popCommentDetailVC(with popType: PopType) {
    self.router?.detachCommentDetailRIB(with: popType)
  }
  
  func didTapCloseButton() {
    self.listener?.didTapCloseButton()
  }
}
