//
//  FollowBoardBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import User
import Networking

import RIBs

protocol FollowBoardDependency: Dependency {
  var boardRepository: BoardRepository { get }
  var userManager: MutableUserManagerStream { get }
  var postingCategoryFilter: MutableSelectedPostingFilterStream { get }
}

final class FollowBoardComponent: Component<FollowBoardDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FollowBoardBuildable: Buildable {
  func build(withListener listener: FollowBoardListener) -> FollowBoardRouting
}

final class FollowBoardBuilder: Builder<FollowBoardDependency>, FollowBoardBuildable {
  
  override init(dependency: FollowBoardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FollowBoardListener) -> FollowBoardRouting {
    let component = FollowBoardComponent(dependency: dependency)
    let viewController = FollowBoardViewController()
    let interactor = FollowBoardInteractor(
      presenter: viewController,
      boardRepository: dependency.boardRepository,
      userManager: dependency.userManager,
      postingCategoryFilter: dependency.postingCategoryFilter
    )
    interactor.listener = listener
    return FollowBoardRouter(interactor: interactor, viewController: viewController)
  }
}
