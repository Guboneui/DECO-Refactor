//
//  CommentBaseBuilder.swift
//  Comment
//
//  Created by 구본의 on 2023/07/25.
//

import User
import Networking

import RIBs

public protocol CommentBaseDependency: Dependency {
  var boardRepository: BoardRepository { get }
  var userManager: MutableUserManagerStream { get }
}

final class CommentBaseComponent:
  Component<CommentBaseDependency>,
  CommentDependency
{
  
  var boardRepository: BoardRepository { dependency.boardRepository }
  var userManager: MutableUserManagerStream { dependency.userManager }
}

// MARK: - Builder

public protocol CommentBaseBuildable: Buildable {
  func build(withListener listener: CommentBaseListener, boardID: Int) -> CommentBaseRouting
}

public final class CommentBaseBuilder: Builder<CommentBaseDependency>, CommentBaseBuildable {
  
  public override init(dependency: CommentBaseDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: CommentBaseListener, boardID: Int) -> CommentBaseRouting {
    let component = CommentBaseComponent(dependency: dependency)
    let viewController = CommentBaseViewController()
    let interactor = CommentBaseInteractor(presenter: viewController, boardID: boardID)
    interactor.listener = listener
    
    let commentBuildable = CommentBuilder(dependency: component)
    
    return CommentBaseRouter(
      interactor: interactor,
      viewController: viewController,
      commentBuildable: commentBuildable
    )
  }
}
