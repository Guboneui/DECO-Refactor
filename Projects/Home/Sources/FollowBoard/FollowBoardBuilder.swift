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
  var userProfileRepository: UserProfileRepository { get }
  var followRepository: FollowRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
}

final class FollowBoardComponent:
  Component<FollowBoardDependency>,
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

protocol FollowBoardBuildable:
  Buildable
{
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
      postingCategoryFilter: dependency.postingCategoryFilter,
      boardListStream: component.boardListStream
    )
    
    interactor.listener = listener
    
    let homeBoardFeedBuildable = HomeBoardFeedBuilder(dependency: component)
    
    return FollowBoardRouter(
      interactor: interactor,
      viewController: viewController,
      homeBoardFeedBuildable: homeBoardFeedBuildable
    )
  }
}
