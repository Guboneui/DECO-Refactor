//
//  MainBuilder.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs
import Home
import Product
import Bookmark
import Profile

public protocol MainDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class MainComponent:
  Component<MainDependency>,
  HomeDependency,
  ProductDependency,
  BookmarkDependency,
  ProfileDependency

{
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol MainBuildable: Buildable {
  func build(withListener listener: MainListener) -> MainRouting
}

final public class MainBuilder: Builder<MainDependency>, MainBuildable {
  
  override public init(dependency: MainDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: MainListener) -> MainRouting {
    let component = MainComponent(dependency: dependency)
    let viewController = MainViewController()
    let interactor = MainInteractor(presenter: viewController)
    interactor.listener = listener
    
    let homeBuilder = HomeBuilder(dependency: component)
    let productBuilder = ProductBuilder(dependency: component)
    let bookmarkBuilder = BookmarkBuilder(dependency: component)
    let profileBuilder = ProfileBuilder(dependency: component)
    
    return MainRouter(
      interactor: interactor,
      viewController: viewController,
      homeBuildable: homeBuilder,
      productBuildable: productBuilder,
      bookmarkBuildable: bookmarkBuilder,
      profileBuildable: profileBuilder
    )
  }
}
