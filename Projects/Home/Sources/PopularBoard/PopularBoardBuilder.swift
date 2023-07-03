//
//  PopularBoardBuilder.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import Networking

import RIBs

protocol PopularBoardDependency: Dependency {
  var boardRepository: BoardRepository { get }
}

final class PopularBoardComponent: Component<PopularBoardDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PopularBoardBuildable: Buildable {
  func build(withListener listener: PopularBoardListener) -> PopularBoardRouting
}

final class PopularBoardBuilder: Builder<PopularBoardDependency>, PopularBoardBuildable {
  
  override init(dependency: PopularBoardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: PopularBoardListener) -> PopularBoardRouting {
    let component = PopularBoardComponent(dependency: dependency)
    let viewController = PopularBoardViewController()
    let interactor = PopularBoardInteractor(
      presenter: viewController,
      boardRepository: dependency.boardRepository
    )
    interactor.listener = listener
    return PopularBoardRouter(interactor: interactor, viewController: viewController)
  }
}
