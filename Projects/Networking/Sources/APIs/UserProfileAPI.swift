//
//  UserProfileAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/27.
//

import Foundation
import Moya

enum UserProfileAPI {
  case userPostings(Int, Int, Int)
}

extension UserProfileAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    switch self {
    case .userPostings(let id, _, _):
      return "/board/list/\(id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userPostings:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .userPostings(_, let userID, let createdAt):
      return .requestParameters(parameters: ["userId":userID, "createdAt":createdAt], encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

