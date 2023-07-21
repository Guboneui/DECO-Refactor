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
  case boardInfo(Int, Int)
  case boardLike(Int, Int)
  case boardDisLike(Int, Int)
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
    case .boardInfo(let boardID, _):
      return "\(defaultURL)/\(boardID)"
    case .boardLike(let boardID, _):
      return "\(defaultURL)/like/\(boardID)"
    case .boardDisLike(let boardID, _):
      return "\(defaultURL)/dislike/\(boardID)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .boardCategoryList, .boardInfo:
      return .get
    case .boardList, .boardLike, .boardDisLike:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .boardCategoryList:
      return .requestPlain
    case .boardList(let param):
      return .requestParameters(parameters: param.toDictionary, encoding: JSONEncoding.default)
    case .boardInfo(_, let userID):
      return .requestParameters(parameters: ["userId":userID], encoding: URLEncoding.queryString)
    case .boardLike(_, let userID):
      return .requestParameters(parameters: ["userId":userID], encoding: JSONEncoding.default)
    case .boardDisLike(_, let userID):
      return .requestParameters(parameters: ["userId":userID], encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

