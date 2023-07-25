//
//  CommentDetailInteractor.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import Util
import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol CommentDetailRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CommentDetailPresentable: Presentable {
  var listener: CommentDetailPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CommentDetailListener: AnyObject {
  func popCommentDetailVC(with popType: PopType)
  func didTapCloseButton()
}

final class CommentDetailInteractor: PresentableInteractor<CommentDetailPresentable>, CommentDetailInteractable, CommentDetailPresentableListener {
  
  weak var router: CommentDetailRouting?
  weak var listener: CommentDetailListener?
  
  var childCommentList: BehaviorRelay<[CommentDTO]> = .init(value: [])
  
  private let boardID: Int
  private let parentComment: CommentDTO
  private let commentParentID: Int
  private let userManager: MutableUserManagerStream
  private let boardRepository: BoardRepository
  
  init(
    presenter: CommentDetailPresentable,
    boardID: Int,
    parentComment: CommentDTO,
    commentParentID: Int,
    userManager: MutableUserManagerStream,
    boardRepository: BoardRepository
  ) {
    self.boardID = boardID
    self.parentComment = parentComment
    self.commentParentID = commentParentID
    self.userManager = userManager
    self.boardRepository = boardRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchDetailCommentList()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popCommentDetailVC(with popType: PopType) {
    self.listener?.popCommentDetailVC(with: popType)
  }
  
  func didTapCloseButton() {
    self.listener?.didTapCloseButton()
  }
  
  private func fetchDetailCommentList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let childCommentList = await self.boardRepository.boardCommentList(
        createdAt: Int.max,
        parentCommentID: self.commentParentID,
        userID: self.userManager.userID,
        boardID: self.boardID
      ) {
        self.childCommentList.accept([self.parentComment] + childCommentList)
      }
    }
  }
  
  func fetchChildCommentListNextPage(at createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let list = await self.boardRepository.boardCommentList(
        createdAt: createdAt,
        parentCommentID: self.commentParentID,
        userID: self.userManager.userID,
        boardID: self.boardID
      ), !list.isEmpty {
        let prevList = self.childCommentList.value
        self.childCommentList.accept(prevList + list)
      }
    }
  }
}
