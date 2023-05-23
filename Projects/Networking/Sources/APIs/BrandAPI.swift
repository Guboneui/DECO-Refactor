//
//  BrandAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/22.
//

import Foundation
import Moya

enum BrandAPI {
  case brandList
  case brandProductUsagePosting(Int, Int, Int)
}

extension BrandAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    let defaultPath = "/brand"
    switch self {
    case .brandList:
      return "\(defaultPath)"
    case .brandProductUsagePosting(let brandID, _, _):
      return "\(defaultPath)/\(brandID)/posting"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .brandList, .brandProductUsagePosting:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .brandList:
      return .requestPlain
      
    case .brandProductUsagePosting(_, let userID, let createdAt):
      return .requestParameters(
        parameters: [
          "userId": userID,
          "createdAt": createdAt
        ],
        encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

