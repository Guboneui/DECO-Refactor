//
//  HomeBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import Networking

import RIBs

public protocol HomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class HomeComponent: Component<HomeDependency> {
  var boardRepository: BoardRepository = BoardRepositoryImpl()
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
    let interactor = HomeInteractor(
      presenter: viewController,
      boardRepository: component.boardRepository
    )
    interactor.listener = listener
    
    
    return HomeRouter(
      interactor: interactor,
      viewController: viewController
    )
  }
}
