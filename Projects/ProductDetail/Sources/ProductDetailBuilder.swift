//
//  ProductDetailBuilder.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import User
import Entity
import Networking

import RIBs

public protocol ProductDetailDependency: Dependency {
  var userManager: MutableUserManagerStream { get }
  var productRepository: ProductRepository { get }
  var bookmarkRepository: BookmarkRepository { get }
  var productListStream: MutableProductStream { get }
}

final class ProductDetailComponent: Component<ProductDetailDependency> {
  var userManager: MutableUserManagerStream { dependency.userManager }
  var productRepository: ProductRepository { dependency.productRepository }
  var bookmarkRepository: BookmarkRepository { dependency.bookmarkRepository }
  var productListStream: MutableProductStream { dependency.productListStream }
}

// MARK: - Builder

public protocol ProductDetailBuildable: Buildable {
  func build(withListener listener: ProductDetailListener, productInfo: ProductDTO) -> ProductDetailRouting
}

final public class ProductDetailBuilder: Builder<ProductDetailDependency>, ProductDetailBuildable {
  
  public override init(dependency: ProductDetailDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: ProductDetailListener, productInfo: ProductDTO) -> ProductDetailRouting {
    let component = ProductDetailComponent(dependency: dependency)
    let viewController = ProductDetailViewController()
    let interactor = ProductDetailInteractor(
      presenter: viewController,
      productInfo: productInfo,
      userManager: component.userManager,
      productRepository: component.productRepository,
      bookmarkRepository: component.bookmarkRepository,
      productStreamManager: component.productListStream
    )
    interactor.listener = listener
    return ProductDetailRouter(interactor: interactor, viewController: viewController)
  }
}
