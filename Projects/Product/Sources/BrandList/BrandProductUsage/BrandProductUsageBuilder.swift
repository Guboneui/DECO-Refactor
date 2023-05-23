//
//  BrandProductUsageBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/24.
//

import Entity
import Networking

import RIBs

protocol BrandProductUsageDependency: Dependency {
  var brandRepository: BrandRepository { get }
}

final class BrandProductUsageComponent: Component<BrandProductUsageDependency> {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BrandProductUsageBuildable: Buildable {
  func build(withListener listener: BrandProductUsageListener, brandInfo: BrandDTO) -> BrandProductUsageRouting
}

final class BrandProductUsageBuilder: Builder<BrandProductUsageDependency>, BrandProductUsageBuildable {
  
  override init(dependency: BrandProductUsageDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: BrandProductUsageListener,
    brandInfo: BrandDTO
  ) -> BrandProductUsageRouting {
    let component = BrandProductUsageComponent(dependency: dependency)
    let viewController = BrandProductUsageViewController()
    let interactor = BrandProductUsageInteractor(
      presenter: viewController,
      brandInfo: brandInfo,
      brandRepository: dependency.brandRepository
    )
    interactor.listener = listener
    return BrandProductUsageRouter(interactor: interactor, viewController: viewController)
  }
}
