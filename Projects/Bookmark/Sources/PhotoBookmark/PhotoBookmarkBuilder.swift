//
//  PhotoBookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import User
import Networking

import RIBs

protocol PhotoBookmarkDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var boardRepository: BoardRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
}

final class PhotoBookmarkComponent: Component<PhotoBookmarkDependency> {
  
  
}

// MARK: - Builder

protocol PhotoBookmarkBuildable: Buildable {
  func build(withListener listener: PhotoBookmarkListener) -> PhotoBookmarkRouting
}

final class PhotoBookmarkBuilder: Builder<PhotoBookmarkDependency>, PhotoBookmarkBuildable {
  
  override init(dependency: PhotoBookmarkDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: PhotoBookmarkListener) -> PhotoBookmarkRouting {
    let component = PhotoBookmarkComponent(dependency: dependency)
    let viewController = PhotoBookmarkViewController()
    let interactor = PhotoBookmarkInteractor(
      presenter: viewController,
      userManager: dependency.userManager,
      boardRepository: dependency.boardRepository,
      bookmarkRepository: dependency.bookmarkRepository
    )
    interactor.listener = listener
    return PhotoBookmarkRouter(interactor: interactor, viewController: viewController)
  }
}
