//
//  SearchProductBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import User
import Networking
import ProductDetail
import RIBs

protocol SearchProductDependency: Dependency {
  var searchText: String { get }
  var searchRepository: SearchRepository { get }
  var userManager: MutableUserManagerStream { get }
  var productListStream: MutableProductStream { get }
  var bookmarkRepository: BookmarkRepository { get }
}

final class SearchProductComponent:
  Component<SearchProductDependency>,
  SearchProductFilterDependency
{
  
  var searchText: String { dependency.searchText }
  var productListStream: MutableProductStream { dependency.productListStream }
  var bookmarkRepository: BookmarkRepository { dependency.bookmarkRepository }
}

// MARK: - Builder

protocol SearchProductBuildable: Buildable {
  func build(withListener listener: SearchProductListener) -> SearchProductRouting
}

final class SearchProductBuilder: Builder<SearchProductDependency>, SearchProductBuildable {
  
  override init(dependency: SearchProductDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchProductListener) -> SearchProductRouting {
    let component = SearchProductComponent(dependency: dependency)
    let viewController = SearchProductViewController()
    let interactor = SearchProductInteractor(
      presenter: viewController,
      searchText: component.searchText,
      searchRepository: dependency.searchRepository,
      bookmarkRepository: component.bookmarkRepository,
      userManager: dependency.userManager,
      productStreamManager: component.productListStream
    )
    
    interactor.listener = listener
    
    let searchProductFilterBuilder = SearchProductFilterBuilder(dependency: component)
    
    return SearchProductRouter(
      interactor: interactor,
      viewController: viewController,
      searchProductFilterBuildable: searchProductFilterBuilder
    )
  }
}
