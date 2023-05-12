//
//  HomeBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs

public protocol HomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class HomeComponent: Component<HomeDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol HomeBuildable: Buildable {
  func build(withListener listener: HomeListener) -> HomeRouting
}

final public class HomeBuilder: Builder<HomeDependency>, HomeBuildable {
  
  override public init(dependency: HomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: HomeListener) -> HomeRouting {
    let component = HomeComponent(dependency: dependency)
    let viewController = HomeViewController()
    let interactor = HomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    
    return HomeRouter(
      interactor: interactor,
      viewController: viewController
    )
  }
}
