//
//  HomeBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import User
import Networking

import RIBs

public protocol HomeDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
}

final class HomeComponent:
  Component<HomeDependency>,
  LatestBoardDependency,
  PopularBoardDependency,
  FollowBoardDependency
{
  var userManager: User.MutableUserManagerStream { dependency.userManager }
  
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
    
    let latestBoardBuildable = LatestBoardBuilder(dependency: component)
    let popularBoardBuildable = PopularBoardBuilder(dependency: component)
    let followBoardBuildable = FollowBoardBuilder(dependency: component)
    
    return HomeRouter(
      interactor: interactor,
      viewController: viewController,
      latestBoardBuildable: latestBoardBuildable,
      popularBoardBuildable: popularBoardBuildable,
      followBoardBuildable: followBoardBuildable
    )
  }
}
