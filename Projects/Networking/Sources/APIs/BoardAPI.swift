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
  case boardCommentList(Int, Int, Int, Int)
  case boardDelete(Int, Int)
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
    case .boardCommentList(_, _, _, let boardID):
      return "\(defaultURL)/reply/\(boardID)"
    case .boardDelete:
      return "\(defaultURL)/delete"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .boardCategoryList, .boardInfo, .boardCommentList:
      return .get
    case .boardList, .boardLike, .boardDisLike, .boardDelete:
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
    case .boardCommentList(let createdAt, let parentReplyID, let userID, _):
      return .requestParameters(parameters: ["createdAt":createdAt, "parentReplyId":parentReplyID, "userId":userID], encoding: URLEncoding.queryString)
    case .boardDelete(let userID, let postingID):
      return .requestParameters(parameters: ["userId":userID, "postingId":postingID], encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}
