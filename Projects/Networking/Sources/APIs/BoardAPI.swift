//
//  BoardAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/29.
//

import Foundation
import Moya

enum BoardAPI {
  case boardCategoryList
}

extension BoardAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    let defaultURL: String = "/board"
    switch self {
    case .boardCategoryList:
      return "\(defaultURL)/category/list"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .boardCategoryList:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .boardCategoryList:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

