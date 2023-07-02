//
//  BoardAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/29.
//

import Foundation
import Moya
import Entity

enum BoardAPI {
  case boardCategoryList
  case boardList(BoardRequestDTO)
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
    case .boardList:
      return "\(defaultURL)/list"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .boardCategoryList:
      return .get
    case .boardList:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .boardCategoryList:
      return .requestPlain
    case .boardList(let param):
      return .requestParameters(parameters: param.toDictionary, encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

