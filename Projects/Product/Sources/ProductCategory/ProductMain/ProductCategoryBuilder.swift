//
//  ProductCategoryBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import User

import RIBs
import Networking

protocol ProductCategoryDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var userManager: MutableUserManagerStream { get }
  var productRepositoryImpl: ProductRepository { get }
}

final class ProductCategoryComponent:
  Component<ProductCategoryDependency>,
  ProductCategoryDetailDependency,
  ProductMoodDetailDependency
{
  var userManager: MutableUserManagerStream { dependency.userManager }
  var productRepository: ProductRepository { dependency.productRepositoryImpl }
  var bookmarkRepository: BookmarkRepository = BookmarkRepositoryImpl()
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream = SelectedFilterInProductCategoryStreamImpl()
  var selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream = SelectedFilterInProductMoodStreamImpl()
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
      productRepository: dependency.productRepositoryImpl,
      selectedFilterInProductCategory: component.selectedFilterInProductCategory,
      selectedFilterInProductMood: component.selectedFilterInProductMood
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
