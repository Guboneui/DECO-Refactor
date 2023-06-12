//
//  SearchBrandBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Networking

import RIBs

protocol SearchBrandDependency: Dependency {
  var searchText: String { get }
  var searchRepository: SearchRepository { get }
  
}

final class SearchBrandComponent: Component<SearchBrandDependency> {
  var searchText: String { dependency.searchText }
}

// MARK: - Builder

protocol SearchBrandBuildable: Buildable {
  func build(withListener listener: SearchBrandListener) -> SearchBrandRouting
}

final class SearchBrandBuilder: Builder<SearchBrandDependency>, SearchBrandBuildable {
  
  override init(dependency: SearchBrandDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchBrandListener) -> SearchBrandRouting {
    let component = SearchBrandComponent(dependency: dependency)
    let viewController = SearchBrandViewController()
    let interactor = SearchBrandInteractor(
      presenter: viewController,
      searchText: component.searchText,
      searchRepository: dependency.searchRepository
    )
    interactor.listener = listener
    return SearchBrandRouter(interactor: interactor, viewController: viewController)
  }
}
