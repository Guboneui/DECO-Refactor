//
//  ProductCategoryBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs
import Networking

protocol ProductCategoryDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  
  var productRepositoryImpl: ProductRepository { get }
}

final class ProductCategoryComponent:
  Component<ProductCategoryDependency>,
  ProductCategoryDetailDependency,
  ProductMoodDetailDependency
{
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductCategoryBuildable: Buildable {
  func build(withListener listener: ProductCategoryListener) -> ProductCategoryRouting
}

final class ProductCategoryBuilder: Builder<ProductCategoryDependency>, ProductCategoryBuildable {
  
  override init(dependency: ProductCategoryDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: ProductCategoryListener) -> ProductCategoryRouting {
    let component = ProductCategoryComponent(dependency: dependency)
    let viewController = ProductCategoryViewController()
    let interactor = ProductCategoryInteractor(
      presenter: viewController,
      productRepository: dependency.productRepositoryImpl
    )
    interactor.listener = listener
    
    let productCategoryDetailBuilder = ProductCategoryDetailBuilder(dependency: component)
    let productMoodDetailBuilder = ProductMoodDetailBuilder(dependency: component)
    
    return ProductCategoryRouter(
      interactor: interactor,
      viewController: viewController,
      productCategoryDetailBuildable: productCategoryDetailBuilder,
      productMoodDetailBuildable: productMoodDetailBuilder
    )
  }
}
