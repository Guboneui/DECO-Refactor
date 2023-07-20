//
//  LatestBoardBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import User
import Networking

import RIBs

protocol LatestBoardDependency: Dependency {
  var boardRepository: BoardRepository { get }
  var userManager: MutableUserManagerStream { get }
  var postingCategoryFilter: MutableSelectedPostingFilterStream { get }
}

final class LatestBoardComponent:
  Component<LatestBoardDependency>,
  LatestBoardFeedDependency
{
  
  var boardListStream: MutableBoardStream = BoardStreamImpl()
}

// MARK: - Builder

protocol LatestBoardBuildable: Buildable {
  func build(withListener listener: LatestBoardListener) -> LatestBoardRouting
}

final class LatestBoardBuilder: Builder<LatestBoardDependency>, LatestBoardBuildable {
  
  override init(dependency: LatestBoardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: LatestBoardListener) -> LatestBoardRouting {
    let component = LatestBoardComponent(dependency: dependency)
    let viewController = LatestBoardViewController()
    let interactor = LatestBoardInteractor(
      presenter: viewController,
      boardRepository: dependency.boardRepository,
      userManager: dependency.userManager,
      postingCategoryFilter: dependency.postingCategoryFilter,
      boardListStream: component.boardListStream
    )
    interactor.listener = listener
    
    let latestBoardFeedBuildable = LatestBoardFeedBuilder(dependency: component)
    
    return LatestBoardRouter(
      interactor: interactor,
      viewController: viewController,
      latestBoardFeedBuildable: latestBoardFeedBuildable
    )
  }
  
  }
}
