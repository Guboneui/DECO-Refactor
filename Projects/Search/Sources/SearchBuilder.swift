//
//  SearchBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import User
import Networking

import RIBs

public protocol SearchDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
}

final class SearchComponent:
  Component<SearchDependency>,
  SearchResultDependency
{
  
  var userManager: MutableUserManagerStream { dependency.userManager }
  var searchRepository: SearchRepository { SearchRepositoryImpl() }
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
