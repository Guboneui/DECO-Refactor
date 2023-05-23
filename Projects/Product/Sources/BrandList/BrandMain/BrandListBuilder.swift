//
//  BrandListBuilder.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs

import Entity
import Networking

protocol BrandListDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
  var brandRepositoryImpl: BrandRepository { get }
}

final class BrandListComponent:
  Component<BrandListDependency>,
  BrandDetailDependency
{
  var brandRepository: Networking.BrandRepository { dependency.brandRepositoryImpl }
  
  
  //var brandInfo: BrandDTO = BrandDTO(desecription
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BrandListBuildable: Buildable {
  func build(withListener listener: BrandListListener) -> BrandListRouting
}

final class BrandListBuilder: Builder<BrandListDependency>, BrandListBuildable {
  
  override init(dependency: BrandListDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: BrandListListener) -> BrandListRouting {
    let component = BrandListComponent(dependency: dependency)
    let viewController = BrandListViewController()
    let interactor = BrandListInteractor(
      presenter: viewController,
      brandRepository: dependency.brandRepositoryImpl
    )
    
    interactor.listener = listener
    
    let brandDetailBuilder = BrandDetailBuilder(dependency: component)
    
    return BrandListRouter(
      interactor: interactor,
      viewController: viewController,
      brandDetailBuildable: brandDetailBuilder
    )
  }
}
