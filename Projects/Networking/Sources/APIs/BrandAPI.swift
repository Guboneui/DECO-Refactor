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
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .brandList:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .brandList:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

