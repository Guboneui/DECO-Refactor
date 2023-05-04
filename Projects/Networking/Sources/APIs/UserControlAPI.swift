//
//  UserControlAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Foundation
import Moya

enum UserControlAPI {
  case checkNickname(nickname: String)
}

extension UserControlAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    let defaultPath = "/user"
    switch self {
    case .checkNickname:
      return "\(defaultPath)/checkNickname"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .checkNickname:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .checkNickname(let nickname):
      return .requestParameters(parameters: ["nickname":nickname], encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}
