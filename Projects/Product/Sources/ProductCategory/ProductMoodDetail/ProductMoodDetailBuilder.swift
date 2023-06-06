//
//  ProductMoodDetailBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import User
import Util
import Networking

import RIBs

protocol ProductMoodDetailDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var productRepository: ProductRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
  var selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream { get }
  
}

final class ProductMoodDetailComponent:
  Component<ProductMoodDetailDependency>,
  MoodModalDependency,
  CategoryColorModalDependency
{
  
  var selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream { dependency.selectedFilterInProductMood }
}

// MARK: - Builder

protocol ProductMoodDetailBuildable: Buildable {
  func build(withListener listener: ProductMoodDetailListener) -> ProductMoodDetailRouting
}

final class ProductMoodDetailBuilder: Builder<ProductMoodDetailDependency>, ProductMoodDetailBuildable {
  
  override init(dependency: ProductMoodDetailDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: ProductMoodDetailListener) -> ProductMoodDetailRouting {
    let component = ProductMoodDetailComponent(dependency: dependency)
    let viewController = ProductMoodDetailViewController()
    let interactor = ProductMoodDetailInteractor(
      presenter: viewController,
      productRepository: dependency.productRepository,
      bookmarkRepository: dependency.bookmarkRepository,
      userManager: dependency.userManager,
      selectedFilterInProductMood: dependency.selectedFilterInProductMood
    )
    interactor.listener = listener
    
    let moodModalBuilder = MoodModalBuilder(dependency: component)
    let categoryColorModalBuilder = CategoryColorModalBuilder(dependency: component)
    return ProductMoodDetailRouter(
      interactor: interactor,
      viewController: viewController,
      moodModalBuildable: moodModalBuilder,
      categoryColorModalBuildable: categoryColorModalBuilder
    )
  }
}
