//
//  SearchUserBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Networking
import RIBs

protocol SearchUserDependency: Dependency {
  var searchText: String { get }
  var searchRepository: SearchRepository { get }
}

final class SearchUserComponent: Component<SearchUserDependency> {
  
  var searchText: String { dependency.searchText }
}

// MARK: - Builder

protocol SearchUserBuildable: Buildable {
  func build(withListener listener: SearchUserListener) -> SearchUserRouting
}

final class SearchUserBuilder: Builder<SearchUserDependency>, SearchUserBuildable {
  
  override init(dependency: SearchUserDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchUserListener) -> SearchUserRouting {
    let component = SearchUserComponent(dependency: dependency)
    let viewController = SearchUserViewController()
    let interactor = SearchUserInteractor(
      presenter: viewController,
      searchText: component.searchText,
      searchRepository: dependency.searchRepository
    )
    interactor.listener = listener
    return SearchUserRouter(interactor: interactor, viewController: viewController)
  }
}
