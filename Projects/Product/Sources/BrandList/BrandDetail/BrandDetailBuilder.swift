//
//  BrandDetailBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import Entity
import Networking

import RIBs

protocol BrandDetailDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var brandRepository: BrandRepository { get }
}

final class BrandDetailComponent: Component<BrandDetailDependency> {
  var brandRepository: BrandRepository { dependency.brandRepository }
  var productRepository: ProductRepository { ProductRepositoryImpl() }
}

// MARK: - Builder

protocol BrandDetailBuildable: Buildable {
  func build(
    withListener listener: BrandDetailListener,
    brandInfo: BrandDTO
  ) -> BrandDetailRouting
}

final class BrandDetailBuilder: Builder<BrandDetailDependency>, BrandDetailBuildable {
  
  override init(dependency: BrandDetailDependency) {
    super.init(dependency: dependency)
  }
  
  func build(
    withListener listener: BrandDetailListener,
    brandInfo: BrandDTO
  ) -> BrandDetailRouting {
    let component = BrandDetailComponent(dependency: dependency)
    let viewController = BrandDetailViewController()
    let interactor = BrandDetailInteractor(
      presenter: viewController,
      brandInfo: brandInfo,
      brandRepository: component.brandRepository,
      productRepository: component.productRepository
    )
    interactor.listener = listener
    return BrandDetailRouter(interactor: interactor, viewController: viewController)
  }
}
