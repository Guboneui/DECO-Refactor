//
//  SearchBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import RIBs

public protocol SearchDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class SearchComponent:
  Component<SearchDependency>,
  SearchResultDependency
{
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol SearchBuildable: Buildable {
  func build(withListener listener: SearchListener) -> SearchRouting
}

final public class SearchBuilder: Builder<SearchDependency>, SearchBuildable {
  
  public override init(dependency: SearchDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: SearchListener) -> SearchRouting {
    let component = SearchComponent(dependency: dependency)
    let viewController = SearchViewController()
    let interactor = SearchInteractor(presenter: viewController)
    interactor.listener = listener
    
    let searchResultBuilder = SearchResultBuilder(dependency: component)
    
    return SearchRouter(
      interactor: interactor,
      viewController: viewController,
      searchResultBuildable: searchResultBuilder
    )
  }
}
