//
//  ProductAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/16.
//

import Foundation
import Entity
import Moya

enum ProductAPI {
  case productCategoryList
  case productMoodList
  case productInfo(Int, Int)
  case productOfCategory(ItemFilterRequest)
}

extension ProductAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    switch self {
    case .productCategoryList:
      return "/itemCategory/list"
    case .productMoodList:
      return "/style/second/list"
    case .productInfo(let productID, _):
      return "/item/\(productID)"
    case .productOfCategory:
      return "/item/filter"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .productCategoryList, .productMoodList, .productInfo:
      return .get
    case .productOfCategory:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .productCategoryList, .productMoodList:
      return .requestPlain
    case .productInfo(_, let userID):
      return .requestParameters(parameters: ["userId":userID], encoding: URLEncoding.queryString)
    case .productOfCategory(let param):
      return .requestParameters(parameters: param.toDictionary, encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}
