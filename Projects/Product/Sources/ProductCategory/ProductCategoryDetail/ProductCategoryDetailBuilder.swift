//
//  ProductCategoryDetailBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import User
import Util
import Entity
import Networking
import ProductDetail

import RIBs

protocol ProductCategoryDetailDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var productRepository: ProductRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream { get }
}

final class ProductCategoryDetailComponent:
  Component<ProductCategoryDetailDependency>,
  CategoryModalDependency,
  MoodColorModalDependency,
  ProductDetailDependency
{
  
  var selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream { dependency.selectedFilterInProductCategory }
  var userManager: MutableUserManagerStream { dependency.userManager }
  var productRepository: ProductRepository { dependency.productRepository }
  var bookmarkRepository: BookmarkRepository { dependency.bookmarkRepository }
  
  var productListStream: MutableProductStream = ProductStreamImpl()
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
      productRepository: component.productRepository,
      bookmarkRepository: component.bookmarkRepository,
      userManager: component.userManager,
      selectedFilterInProductCategory: component.selectedFilterInProductCategory,
      productStreamManager: component.productListStream
    )
    interactor.listener = listener
    
    let categoryModalBuilder = CategoryModalBuilder(dependency: component)
    let moodColorModalBuilder = MoodColorModalBuilder(dependency: component)
    let productDetailBuilder = ProductDetailBuilder(dependency: component)
    
    return ProductCategoryDetailRouter(
      interactor: interactor,
      viewController: viewController,
      categoryModalBuildable: categoryModalBuilder,
      moodColorModalBuildable: moodColorModalBuilder,
      productDetailBuildable: productDetailBuilder
    )
  }
}
