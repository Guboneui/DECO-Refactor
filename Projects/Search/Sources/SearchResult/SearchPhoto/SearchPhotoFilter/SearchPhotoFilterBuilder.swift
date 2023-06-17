//
//  SearchPhotoFilterBuilder.swift
//  Search
//
//  Created by 구본의 on 2023/06/16.
//

import RIBs

protocol SearchPhotoFilterDependency: Dependency {
  var searchPhotoFilterManager: MutableSearchPhotoFilterStream { get }
}

final class SearchPhotoFilterComponent: Component<SearchPhotoFilterDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SearchPhotoFilterBuildable: Buildable {
  func build(withListener listener: SearchPhotoFilterListener) -> SearchPhotoFilterRouting
}

final class SearchPhotoFilterBuilder: Builder<SearchPhotoFilterDependency>, SearchPhotoFilterBuildable {
  
  override init(dependency: SearchPhotoFilterDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SearchPhotoFilterListener) -> SearchPhotoFilterRouting {
    let component = SearchPhotoFilterComponent(dependency: dependency)
    let viewController = SearchPhotoFilterViewController()
    let interactor = SearchPhotoFilterInteractor(
      presenter: viewController,
      searchPhotoFilterManager: dependency.searchPhotoFilterManager
    )
    interactor.listener = listener
    return SearchPhotoFilterRouter(interactor: interactor, viewController: viewController)
  }
}
