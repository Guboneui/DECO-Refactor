//
//  LatestBoardBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import User
import Networking

import RIBs

protocol LatestBoardDependency: Dependency {
  var boardRepository: BoardRepository { get }
  
}

final class LatestBoardComponent: Component<LatestBoardDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LatestBoardBuildable: Buildable {
  func build(withListener listener: LatestBoardListener) -> LatestBoardRouting
}

final class LatestBoardBuilder: Builder<LatestBoardDependency>, LatestBoardBuildable {
  
  override init(dependency: LatestBoardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: LatestBoardListener) -> LatestBoardRouting {
    let component = LatestBoardComponent(dependency: dependency)
    let viewController = LatestBoardViewController()
    let interactor = LatestBoardInteractor(
      presenter: viewController,
      boardRepository: dependency.boardRepository

    )
    interactor.listener = listener
    return LatestBoardRouter(interactor: interactor, viewController: viewController)
  }
}
