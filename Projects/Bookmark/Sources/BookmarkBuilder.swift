//
//  BookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs

public protocol BookmarkDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class BookmarkComponent: Component<BookmarkDependency> {
  
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
    let interactor = BookmarkInteractor(presenter: viewController)
    interactor.listener = listener
    return BookmarkRouter(interactor: interactor, viewController: viewController)
  }
}
