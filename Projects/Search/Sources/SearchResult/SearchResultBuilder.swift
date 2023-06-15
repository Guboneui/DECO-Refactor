//
//  SearchResultBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import User
import Networking
import ProductDetail

import RIBs

protocol SearchResultDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var searchRepository: SearchRepository { get }
}

final class SearchResultComponent:
  Component<SearchResultDependency>,
  SearchPhotoDependency,
  SearchProductDependency,
  SearchBrandDependency,
  SearchUserDependency,
  ProductDetailDependency
{

  var searchText: String
  
  init(dependency: SearchResultDependency, searchText: String) {
    self.searchText = searchText
    super.init(dependency: dependency)
  }
  
  var userManager: MutableUserManagerStream { dependency.userManager }
  var searchRepository: SearchRepository { dependency.searchRepository }
  
  // 체크
  var productRepository: Networking.ProductRepository = ProductRepositoryImpl()
  var bookmarkRepository: Networking.BookmarkRepository = BookmarkRepositoryImpl()
  var productListStream: ProductDetail.MutableProductStream = ProductStreamImpl()
}

// MARK: - Builder

protocol SearchResultBuildable: Buildable {
  func build(withListener listener: SearchResultListener, searchText: String) -> SearchResultRouting
}

final class SearchResultBuilder: Builder<SearchResultDependency>, SearchResultBuildable {
  
  override init(dependency: SearchResultDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchResultListener, searchText: String) -> SearchResultRouting {
    let component = SearchResultComponent(dependency: dependency, searchText: searchText)
    let viewController = SearchResultViewController()
    let interactor = SearchResultInteractor(presenter: viewController, searchText: searchText)
    interactor.listener = listener
    
    let searchPhotoBuilder = SearchPhotoBuilder(dependency: component)
    let searchProductBuilder = SearchProductBuilder(dependency: component)
    let searchBrandBuilder = SearchBrandBuilder(dependency: component)
    let searchUserBuilder = SearchUserBuilder(dependency: component)
    let productDetailBuilder = ProductDetailBuilder(dependency: component)
    
    return SearchResultRouter(
      interactor: interactor,
      viewController: viewController,
      searchPhotoBuildable: searchPhotoBuilder,
      searchProductBuildable: searchProductBuilder,
      searchBrandBuildable: searchBrandBuilder,
      searchUserBuildable: searchUserBuilder,
      productDetailBuildable: productDetailBuilder
    )
  }
}
