//
//  HomeBoardFeedBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/25.
//

import RIBs
import User
import Comment
import Networking
import ProductDetail

protocol HomeBoardFeedDependency: Dependency {
  var boardListStream: MutableBoardStream { get }
  var userManager: MutableUserManagerStream { get }
  var bookmarkRepository: BookmarkRepository { get }
  var boardRepository: BoardRepository { get }
  var userProfileRepository: UserProfileRepository { get }
  var followRepository: FollowRepository { get }
  var postingCategoryFilter: MutableSelectedPostingFilterStream { get }
}

final class HomeBoardFeedComponent:
  Component<HomeBoardFeedDependency>,
  TargetUserProfileDependency,
  CommentBaseDependency,
  ProductDetailDependency
{
  var userManager: User.MutableUserManagerStream { dependency.userManager }
  var userProfileRepository: Networking.UserProfileRepository { dependency.userProfileRepository }
  var followRepository: Networking.FollowRepository { dependency.followRepository }
  var boardRepository: BoardRepository { dependency.boardRepository }
  var productRepository: ProductRepository = ProductRepositoryImpl()
  var bookmarkRepository: Networking.BookmarkRepository = BookmarkRepositoryImpl()
  var productListStream: ProductDetail.MutableProductStream = ProductStreamImpl()
}

// MARK: - Builder

protocol HomeBoardFeedBuildable: Buildable {
  func build(
    withListener listener: HomeBoardFeedListener,
    startIndex: Int,
    feedType: HomeType
  ) -> HomeBoardFeedRouting
}

final class HomeBoardFeedBuilder: Builder<HomeBoardFeedDependency>, HomeBoardFeedBuildable {
  
  override init(dependency: HomeBoardFeedDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: HomeBoardFeedListener,
    startIndex: Int,
    feedType: HomeType
  ) -> HomeBoardFeedRouting {
    let component = HomeBoardFeedComponent(dependency: dependency)
    let viewController = HomeBoardFeedViewController()
    let interactor = HomeBoardFeedInteractor(
      presenter: viewController,
      feedStartIndex: startIndex,
      feedType: feedType,
      boardListStream: dependency.boardListStream,
      userManager: dependency.userManager,
      bookmarkRepository: dependency.bookmarkRepository,
      boardRepository: dependency.boardRepository,
      productRepository: component.productRepository,
      postingCategoryFilter: dependency.postingCategoryFilter
    )
    
    interactor.listener = listener
    
    let targetUserProfileBuildable = TargetUserProfileBuilder(dependency: component)
    let commentBaseBuildable = CommentBaseBuilder(dependency: component)
    let productDetailBuildable = ProductDetailBuilder(dependency: component)
    
    return HomeBoardFeedRouter(
      interactor: interactor,
      viewController: viewController,
      targetUserProfileBuildable: targetUserProfileBuildable,
      commentBaseBuildable: commentBaseBuildable,
      productDetailBuildable: productDetailBuildable
    )
  }
}
