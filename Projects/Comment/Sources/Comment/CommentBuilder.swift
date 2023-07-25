//
//  CommentBuilder.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import User
import Networking

import RIBs

protocol CommentDependency: Dependency {
  var boardRepository: BoardRepository { get }
  var userManager: MutableUserManagerStream { get }
}

final class CommentComponent:
  Component<CommentDependency>,
  CommentDetailDependency
{
  var userManager: MutableUserManagerStream { dependency.userManager }
  var boardRepository: BoardRepository { dependency.boardRepository }
}

// MARK: - Builder

protocol CommentBuildable: Buildable {
  func build(withListener listener: CommentListener, boardID: Int) -> CommentRouting
}

final class CommentBuilder: Builder<CommentDependency>, CommentBuildable {
  
  override init(dependency: CommentDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: CommentListener, boardID: Int) -> CommentRouting {
    let component = CommentComponent(dependency: dependency)
    let viewController = CommentViewController()
    let interactor = CommentInteractor(
      presenter: viewController,
      boardID: boardID,
      userManager: dependency.userManager,
      boardRepository: dependency.boardRepository
    )
    interactor.listener = listener
    
    let commentDetailBuildable = CommentDetailBuilder(dependency: component)
    
    return CommentRouter(
      interactor: interactor,
      viewController: viewController,
      commentDetailBuildable: commentDetailBuildable
    )
  }
}
