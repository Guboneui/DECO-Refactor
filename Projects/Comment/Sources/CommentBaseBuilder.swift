//
//  CommentBaseBuilder.swift
//  Comment
//
//  Created by 구본의 on 2023/07/25.
//

import RIBs

public protocol CommentBaseDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class CommentBaseComponent: Component<CommentBaseDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
    return CommentBaseRouter(interactor: interactor, viewController: viewController)
  }
}
