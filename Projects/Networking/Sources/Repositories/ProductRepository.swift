//
//  ProductRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/16.
//

import Foundation
import Moya
import Entity

public protocol ProductRepository {
  func getProductCategoryList() async -> [ProductCategoryDTO]?
  func getProductMoodList() async -> [ProductMoodDTO]?
}

public class ProductRepositoryImpl: BaseRepository, ProductRepository {
  public init() {}
  
  let provider = Providers<ProductAPI>.make()
  
  public func getProductCategoryList() async -> [ProductCategoryDTO]? {
    await provider.request(.productCategoryList)
  }
  
  public func getProductMoodList() async -> [ProductMoodDTO]? {
    await provider.request(.productMoodList)
  }
}
