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
  var userProfileRepository: UserProfileRepository { get }
  var followRepository: FollowRepository { get }
  var postingCategoryFilter: MutableSelectedPostingFilterStream { get }
}

final class LatestBoardFeedComponent:
  Component<LatestBoardFeedDependency>,
  TargetUserProfileDependency
{
  var userManager: User.MutableUserManagerStream { dependency.userManager }
  var userProfileRepository: Networking.UserProfileRepository { dependency.userProfileRepository }
  var followRepository: Networking.FollowRepository { dependency.followRepository }
  
  
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
      boardRepository: dependency.boardRepository,
      postingCategoryFilter: dependency.postingCategoryFilter
    )
    interactor.listener = listener
    
    let targetUserProfileBuildable = TargetUserProfileBuilder(dependency: component)
    
    return LatestBoardFeedRouter(
      interactor: interactor,
      viewController: viewController,
      targetUserProfileBuildable: targetUserProfileBuildable
    )
  }
}
