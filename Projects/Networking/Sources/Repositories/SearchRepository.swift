//
//  SearchRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/06/13.
//

import Foundation
import Moya
import Entity

public protocol SearchRepository {
  func getSearchPhotoList(param: BoardFilterRequest) async -> [PostingDTO]?
  func getSearchProductList(param: ItemFilterRequest) async -> [ProductDTO]?
  func getSearchBrandList(brandName: String) async -> [BrandDTO]?
  func getSearchUserList(nickname: String) async -> [SearchUserDTO]?
}

public class SearchRepositoryImpl: BaseRepository, SearchRepository {
  public init() {}
  
  let provider = Providers<SearchAPI>.make()
  
  public func getSearchPhotoList(param: BoardFilterRequest) async -> [PostingDTO]? {
    await provider.request(.searchPhotoList(param))
  }
  
  public func getSearchProductList(param: ItemFilterRequest) async -> [ProductDTO]? {
    await provider.request(.searchProductList(param))
  }
  
  public func getSearchBrandList(brandName: String) async -> [BrandDTO]? {
    await provider.request(.searchBrandList(brandName))
  }
  
  public func getSearchUserList(nickname: String) async -> [SearchUserDTO]? {
    await provider.request(.searchUserList(nickname))
  }
}


