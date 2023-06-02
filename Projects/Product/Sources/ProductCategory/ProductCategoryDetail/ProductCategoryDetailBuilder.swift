//
//  ProductCategoryDetailBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import User
import Util
import Networking

import RIBs

protocol ProductCategoryDetailDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var productRepository: ProductRepository { get }
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream { get }
}

final class ProductCategoryDetailComponent:
  Component<ProductCategoryDetailDependency>,
  CategoryModalDependency,
  MoodColorModalDependency
{
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream { dependency.selectedFilterInProductCategory }
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProductCategoryDetailBuildable: Buildable {
  func build(withListener listener: ProductCategoryDetailListener) -> ProductCategoryDetailRouting
}

final class ProductCategoryDetailBuilder: Builder<ProductCategoryDetailDependency>, ProductCategoryDetailBuildable {
  
  override init(dependency: ProductCategoryDetailDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: ProductCategoryDetailListener) -> ProductCategoryDetailRouting {
    let component = ProductCategoryDetailComponent(dependency: dependency)
    let viewController = ProductCategoryDetailViewController()
    let interactor = ProductCategoryDetailInteractor(
      presenter: viewController,
      productRepository: dependency.productRepository,
      userManager: dependency.userManager,
      selectedFilterInProductCategory: dependency.selectedFilterInProductCategory
    )
    interactor.listener = listener
    
    let categoryModalBuilder = CategoryModalBuilder(dependency: component)
    let moodColorModalBuilder = MoodColorModalBuilder(dependency: component)
    
    return ProductCategoryDetailRouter(
      interactor: interactor,
      viewController: viewController,
      categoryModalBuildable: categoryModalBuilder,
      moodColorModalBuildable: moodColorModalBuilder
    )
  }
}
