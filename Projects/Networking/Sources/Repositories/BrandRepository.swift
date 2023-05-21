//
//  BrandRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/22.
//

import Foundation
import Moya
import Entity

public protocol BrandRepository {
  func getBrandList() async -> [BrandDTO]?
}

public class BrandRepositoryImpl: BaseRepository, BrandRepository {
  public init() {}
  
  let provider = Providers<BrandAPI>.make()
  
  public func getBrandList() async -> [BrandDTO]? {
    await provider.request(.brandList)
  }
}

