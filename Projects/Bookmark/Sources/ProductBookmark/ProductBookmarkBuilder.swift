//
//  ProductBookmarkBuilder.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import User
import Networking

import RIBs

protocol ProductBookmarkDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var productRepository: ProductRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
}

final class ProductBookmarkComponent: Component<ProductBookmarkDependency> {
  
}

// MARK: - Builder

protocol ProductBookmarkBuildable: Buildable {
  func build(withListener listener: ProductBookmarkListener) -> ProductBookmarkRouting
}

final class ProductBookmarkBuilder: Builder<ProductBookmarkDependency>, ProductBookmarkBuildable {
  
  override init(dependency: ProductBookmarkDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: ProductBookmarkListener) -> ProductBookmarkRouting {
    let component = ProductBookmarkComponent(dependency: dependency)
    let viewController = ProductBookmarkViewController()
    let interactor = ProductBookmarkInteractor(
      presenter: viewController,
      userManager: dependency.userManager,
      productRepository: dependency.productRepository,
      bookmarkRepository: dependency.bookmarkRepository
    )
    interactor.listener = listener
    return ProductBookmarkRouter(interactor: interactor, viewController: viewController)
  }
}
