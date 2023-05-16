//
//  ProductAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/16.
//

import Foundation
import Moya

enum ProductAPI {
  case productCategoryList
  case productMoodList
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
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .productCategoryList, .productMoodList:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .productCategoryList, .productMoodList:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}
