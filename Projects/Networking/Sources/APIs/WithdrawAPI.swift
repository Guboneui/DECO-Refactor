//
//  WithdrawAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/06/21.
//

import Foundation
import Moya

enum WithdrawAPI {
  case withdraw(String, String, String)
  case withdrawReason
}

extension WithdrawAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    let defaultPath = "/user/deactivate"
    switch self {
    case .withdraw:
      return "\(defaultPath)"
    case .withdrawReason:
      return "\(defaultPath)/reason"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .withdraw:
      return .post
    case .withdrawReason:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .withdraw:
      return .requestPlain
      
    case .withdrawReason:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}


