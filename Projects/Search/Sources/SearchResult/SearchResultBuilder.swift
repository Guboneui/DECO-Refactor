//
//  SearchResultBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs

protocol SearchResultDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class SearchResultComponent:
  Component<SearchResultDependency>,
  SearchPhotoDependency,
  SearchProductDependency,
  SearchBrandDependency,
  SearchUserDependency
{
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
    let component = SearchResultComponent(dependency: dependency)
    let viewController = SearchResultViewController()
    let interactor = SearchResultInteractor(presenter: viewController, searchText: searchText)
    interactor.listener = listener
    
    let searchPhotoBuilder = SearchPhotoBuilder(dependency: component)
    let searchProductBuilder = SearchProductBuilder(dependency: component)
    let searchBrandBuilder = SearchBrandBuilder(dependency: component)
    let searchUserBuilder = SearchUserBuilder(dependency: component)
    
    return SearchResultRouter(
      interactor: interactor,
      viewController: viewController,
      searchPhotoBuildable: searchPhotoBuilder,
      searchProductBuildable: searchProductBuilder,
      searchBrandBuildable: searchBrandBuilder,
      searchUserBuildable: searchUserBuilder
    )
  }
}
