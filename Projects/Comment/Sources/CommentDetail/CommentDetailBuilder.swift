//
//  CommentDetailBuilder.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import User
import Entity
import Networking

import RIBs

protocol CommentDetailDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var boardRepository: BoardRepository { get }
}

final class CommentDetailComponent: Component<CommentDetailDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CommentDetailBuildable: Buildable {
  func build(
    withListener listener: CommentDetailListener,
    boardID: Int,
    parentComment: CommentDTO,
    commentParentID: Int
  ) -> CommentDetailRouting
}

final class CommentDetailBuilder: Builder<CommentDetailDependency>, CommentDetailBuildable {
  
  override init(dependency: CommentDetailDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: CommentDetailListener, boardID: Int, parentComment: CommentDTO, commentParentID: Int) -> CommentDetailRouting {
    let component = CommentDetailComponent(dependency: dependency)
    let viewController = CommentDetailViewController()
    let interactor = CommentDetailInteractor(
      presenter: viewController,
      boardID: boardID,
      parentComment: parentComment,
      commentParentID: commentParentID,
      userManager: dependency.userManager,
      boardRepository: dependency.boardRepository
    )
    interactor.listener = listener
    return CommentDetailRouter(interactor: interactor, viewController: viewController)
  }
}
