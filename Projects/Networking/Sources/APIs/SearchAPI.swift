//
//  SearchAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/06/13.
//

import Entity

import Foundation
import Moya

enum SearchAPI {
  case searchPhotoList(BoardFilterRequest)
  case searchProductList(ItemFilterRequest)
  case searchBrandList(String)
  case searchUserList(String)
}

extension SearchAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    switch self {
    case .searchPhotoList:
      return "/board/list"
    case .searchProductList:
      return "/item/filter"
    case .searchBrandList:
      return "/brand/search"
    case .searchUserList:
      return "/user/search"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .searchPhotoList, .searchProductList:
      return .post
    case .searchBrandList, .searchUserList:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .searchPhotoList(let param):
      return .requestParameters(
        parameters: param.toDictionary,
        encoding: JSONEncoding.default
      )
      
    case .searchProductList(let param):
      return .requestParameters(
        parameters: param.toDictionary,
        encoding: JSONEncoding.default
      )
    
    case .searchBrandList(let brandName):
      return .requestParameters(
        parameters: [
          "name":brandName,
          "pageIndex":0,
          "fetchCount":1000
        ],
        encoding: URLEncoding.queryString
      )
      
    case .searchUserList(let userName):
      return .requestParameters(parameters: ["nickname":userName], encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}


