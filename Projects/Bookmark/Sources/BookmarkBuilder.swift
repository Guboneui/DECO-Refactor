//
//  BookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import RIBs

public protocol BookmarkDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class BookmarkComponent:
  Component<BookmarkDependency>,
  PhotoBookmarkDependency,
  ProductBookmarkDependency
{
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
    let interactor = BookmarkInteractor(presenter: viewController, viewControllerables: [])
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
