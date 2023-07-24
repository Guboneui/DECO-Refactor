//
//  PopularBoardBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import User
import Networking

import RIBs

protocol PopularBoardDependency: Dependency {
  var boardRepository: BoardRepository { get }
  var userManager: MutableUserManagerStream { get }
  var postingCategoryFilter: MutableSelectedPostingFilterStream { get }
  var userProfileRepository: UserProfileRepository { get }
  var followRepository: FollowRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
}

final class PopularBoardComponent:
  Component<PopularBoardDependency>,
  HomeBoardFeedDependency
{
  var boardListStream: MutableBoardStream = BoardStreamImpl()
  var userManager: MutableUserManagerStream { dependency.userManager }
  var bookmarkRepository: BookmarkRepository { dependency.bookmarkRepository }
  var boardRepository: BoardRepository { dependency.boardRepository }
  var userProfileRepository: UserProfileRepository { dependency.userProfileRepository }
  var followRepository: FollowRepository { dependency.followRepository }
  var postingCategoryFilter: MutableSelectedPostingFilterStream { dependency.postingCategoryFilter }
}

// MARK: - Builder

protocol PopularBoardBuildable: Buildable {
  func build(withListener listener: PopularBoardListener) -> PopularBoardRouting
}

final class PopularBoardBuilder: Builder<PopularBoardDependency>, PopularBoardBuildable {
  
  override init(dependency: PopularBoardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: PopularBoardListener) -> PopularBoardRouting {
    let component = PopularBoardComponent(dependency: dependency)
    let viewController = PopularBoardViewController()
    let interactor = PopularBoardInteractor(
      presenter: viewController,
      boardRepository: dependency.boardRepository,
      userManager: dependency.userManager,
      postingCategoryFilter: dependency.postingCategoryFilter,
      boardListStream: component.boardListStream
    )
    
    interactor.listener = listener
    
    let homeBoardFeedBuildable = HomeBoardFeedBuilder(dependency: component)
    
    return PopularBoardRouter(
      interactor: interactor,
      viewController: viewController,
      homeBoardFeedBuildable: homeBoardFeedBuildable
    )
  }
}
