//
//  FollowAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/30.
//

import Foundation
import Moya

enum FollowAPI {
  case followerList(Int, Int)
  case followingList(Int, Int, String)
  case follow(Int, Int, Bool)
  case unfollow(Int, Int, Bool)
}

extension FollowAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    let defaultPath = "/follow"
    switch self {
    case .followerList(let targetID, _):
      return "\(defaultPath)/\(targetID)"
    case .followingList(let targetID, _, _):
      return "following/search/\(targetID)"
    case .follow(let targetID, _, _):
      return "follow/\(targetID)"
    case .unfollow(let targetID, _, _):
      return "unfollow/\(targetID)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .followerList, .followingList:
      return .get
    case .follow, .unfollow:
      return .post
    }
  }
  
  var task: Task {
    switch self {
    case .followerList(_, let userId):
      return .requestParameters(parameters: ["userId":userId, "pageIndex":0, "pageSize":1000], encoding: URLEncoding.queryString)
    case .followingList(_, let userId, let name):
      return .requestParameters(parameters: ["userId":userId, "name":name], encoding: URLEncoding.queryString)
    case .follow(_, let userID, let follow):
      return .requestParameters(parameters: ["userId":userID, "follow":follow], encoding: JSONEncoding.default)
    case .unfollow(_, let userID, let follow):
      return .requestParameters(parameters: ["userId":userID, "follow":follow], encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

