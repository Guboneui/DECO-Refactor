//
//  SearchPhotoBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import User
import Networking

import RIBs

protocol SearchPhotoDependency: Dependency {
  var searchText: String { get }
  var searchRepository: SearchRepository { get }
  var userManager: MutableUserManagerStream { get }
}

final class SearchPhotoComponent: Component<SearchPhotoDependency> {
  
  var searchText: String { dependency.searchText }
}

// MARK: - Builder

protocol SearchPhotoBuildable: Buildable {
  func build(withListener listener: SearchPhotoListener) -> SearchPhotoRouting
}

final class SearchPhotoBuilder: Builder<SearchPhotoDependency>, SearchPhotoBuildable {
  
  override init(dependency: SearchPhotoDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchPhotoListener) -> SearchPhotoRouting {
    let component = SearchPhotoComponent(dependency: dependency)
    let viewController = SearchPhotoViewController()
    let interactor = SearchPhotoInteractor(
      presenter: viewController,
      searchText: component.searchText,
      searchRepository: dependency.searchRepository,
      userManager: dependency.userManager
    )
    interactor.listener = listener
    return SearchPhotoRouter(interactor: interactor, viewController: viewController)
  }
}
