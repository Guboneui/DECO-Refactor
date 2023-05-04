//
//  GenderBuilder.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol GenderDependency: Dependency {
  
}

final class GenderComponent:
  Component<GenderDependency>,
  AgeDependency
{
  
}

// MARK: - Builder

protocol GenderBuildable: Buildable {
  func build(withListener listener: GenderListener) -> GenderRouting
}

final class GenderBuilder: Builder<GenderDependency>, GenderBuildable {
  
  override init(dependency: GenderDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: GenderListener) -> GenderRouting {
    let component = GenderComponent(dependency: dependency)
    let viewController = GenderViewController()
    let interactor = GenderInteractor(presenter: viewController)
    interactor.listener = listener
    
    let ageBuilder = AgeBuilder(dependency: component)
    return GenderRouter(
      interactor: interactor,
      viewController: viewController,
      ageBuildable: ageBuilder
    )
  }
}
