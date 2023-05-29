//
//  BookmarkAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/29.
//

import Foundation
import Moya

enum BookmarkAPI {
  case bookmarkList(Int, String, Int, Int, Int)
  case addBookmark(Int, Int, Int)
  case deleteBookmark(Int, Int, Int)
}

extension BookmarkAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    let defaultURL: String = "/scrap"
    switch self {
    case .bookmarkList:
      return "\(defaultURL)/list"
    case .addBookmark:
      return "\(defaultURL)/"
    case .deleteBookmark:
      return "\(defaultURL)/delete"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .bookmarkList:
      return .get
    case .addBookmark, .deleteBookmark:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .bookmarkList(let userId, let scrapType, let itemCategoryId, let boardCategoryId, let createdAt):
      return .requestParameters(
        parameters: [
          "userId":userId,
          "scrapType":scrapType,
          "itemCategoryId":itemCategoryId,
          "boardCategoryId":boardCategoryId,
          "createdAt":createdAt
        ], encoding: URLEncoding.queryString)
      
    case .addBookmark(let productId, let boardId, let userId):
      return .requestParameters(parameters: [
        "productId":productId,
        "boardId":boardId,
        "userId":userId
      ], encoding: JSONEncoding.default)
      
    case .deleteBookmark(let productId, let boardId, let userId):
      return .requestParameters(parameters: [
        "productId":productId,
        "boardId":boardId,
        "userId":userId
      ], encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

