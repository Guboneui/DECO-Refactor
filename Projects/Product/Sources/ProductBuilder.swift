//
//  ProductBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import Util
import User
import Search
import Networking

public protocol ProductDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var userManager: MutableUserManagerStream { get }
}

final class ProductComponent:
  Component<ProductDependency>,
  ProductCategoryDependency,
  BrandListDependency,
  SearchDependency
{
  
  fileprivate var productRepository: ProductRepository {
    return ProductRepositoryImpl()
  }
  
  var brandRepository: BrandRepository {
    return BrandRepositoryImpl()
  }
  
  var userManager: MutableUserManagerStream { dependency.userManager }
  
  var productRepositoryImpl: ProductRepository { return productRepository }
  var brandRepositoryImpl: BrandRepository { return brandRepository }
}

// MARK: - Builder

public protocol ProductBuildable: Buildable {
  func build(withListener listener: ProductListener) -> ProductRouting
}

final public class ProductBuilder: Builder<ProductDependency>, ProductBuildable {
  
  override public init(dependency: ProductDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: ProductListener) -> ProductRouting {
    let component = ProductComponent(dependency: dependency)
    let viewController = ProductViewController()
    let interactor = ProductInteractor(
      presenter: viewController,
      productRepository: component.productRepository
    )
    interactor.listener = listener
    
    let productCategoryBuilder = ProductCategoryBuilder(dependency: component)
    let brandListBuilder = BrandListBuilder(dependency: component)
    
    let searchBuilder = SearchBuilder(dependency: component)
    
    return ProductRouter(
      interactor: interactor,
      viewController: viewController,
      productCategoryBuildable: productCategoryBuilder,
      brandListBuildable: brandListBuilder,
      searchBuildable: searchBuilder
    )
  }
}
