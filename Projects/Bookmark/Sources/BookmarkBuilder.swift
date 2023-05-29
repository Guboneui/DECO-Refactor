//
//  BookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import User
import Networking

import RIBs

public protocol BookmarkDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
}

final class BookmarkComponent:
  Component<BookmarkDependency>,
  PhotoBookmarkDependency,
  ProductBookmarkDependency
{
  var userManager: MutableUserManagerStream { dependency.userManager }
  var boardRepository: BoardRepository { BoardRepositoryImpl() }
  var productRepository: ProductRepository { ProductRepositoryImpl() }
  var bookmarkRepository: BookmarkRepository { BookmarkRepositoryImpl() }
}

// MARK: - Builder

public protocol BookmarkBuildable: Buildable {
  func build(withListener listener: BookmarkListener) -> BookmarkRouting
}

final public class BookmarkBuilder: Builder<BookmarkDependency>, BookmarkBuildable {
  
  override public init(dependency: BookmarkDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: BookmarkListener) -> BookmarkRouting {
    let component = BookmarkComponent(dependency: dependency)
    let viewController = BookmarkViewController()
    let interactor = BookmarkInteractor(presenter: viewController)
    interactor.listener = listener
    
    let photoBookmarkBuildable = PhotoBookmarkBuilder(dependency: component)
    let productBookmarkBuildable = ProductBookmarkBuilder(dependency: component)
    
    return BookmarkRouter(
      interactor: interactor,
      viewController: viewController,
      photoBookmarkBuildable: photoBookmarkBuildable,
      productBookmarkBuildable: productBookmarkBuildable
    )
  }
}
