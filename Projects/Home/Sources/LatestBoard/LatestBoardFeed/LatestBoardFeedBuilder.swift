//
//  LatestBoardFeedBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import RIBs
import User
import Networking

protocol LatestBoardFeedDependency: Dependency {
  var boardListStream: MutableBoardStream { get }
  var userManager: MutableUserManagerStream { get }
  var bookmarkRepository: BookmarkRepository { get }
  var boardRepository: BoardRepository { get }
}

final class LatestBoardFeedComponent: Component<LatestBoardFeedDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LatestBoardFeedBuildable: Buildable {
  func build(withListener listener: LatestBoardFeedListener) -> LatestBoardFeedRouting
}

final class LatestBoardFeedBuilder: Builder<LatestBoardFeedDependency>, LatestBoardFeedBuildable {
  
  override init(dependency: LatestBoardFeedDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: LatestBoardFeedListener) -> LatestBoardFeedRouting {
    let component = LatestBoardFeedComponent(dependency: dependency)
    let viewController = LatestBoardFeedViewController()
    let interactor = LatestBoardFeedInteractor(
      presenter: viewController,
      boardListStream: dependency.boardListStream,
      userManager: dependency.userManager,
      bookmarkRepository: dependency.bookmarkRepository,
      boardRepository: dependency.boardRepository
    )
    interactor.listener = listener
    return LatestBoardFeedRouter(interactor: interactor, viewController: viewController)
  }
}
