//
//  UserProfileAPI.swift
//  Networking
//
//  Created by 구본의 on 2023/05/27.
//

import Foundation
import Moya

enum UserProfileAPI {
  case userProfile(Int, Int)
  case userPostings(Int, Int, Int)
  case checkUserBlockStatus(Int, Int)
  case blockUser(Int, Int)
  case unblockUser(Int, Int)
  case editProfile(Int, String, String, String, String, String)
}

extension UserProfileAPI: TargetType {
  var baseURL: URL {
    return DecoURL.API.url
  }
  
  var path: String {
    switch self {
    case .userProfile(let id, _):
      return "/profile/\(id)"
    case .userPostings(let id, _, _):
      return "/board/list/\(id)"
    case .checkUserBlockStatus:
      return "/block/find"
    case .blockUser:
      return "/block"
    case .unblockUser:
      return "/block/off"
    case .editProfile(let userID, _, _, _, _, _):
      return "profile/\(userID)/change"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userProfile, .userPostings, .checkUserBlockStatus:
      return .get
    case .blockUser, .unblockUser:
      return .post
    case .editProfile:
      return .put
    }
  }
  
  var task: Task {
    switch self {
    case .userProfile(_, let userID):
      return .requestParameters(parameters: ["userId":userID], encoding: URLEncoding.queryString)
    case .userPostings(_, let userID, let createdAt):
      return .requestParameters(parameters: ["userId":userID, "createdAt":createdAt], encoding: URLEncoding.queryString)
    case .checkUserBlockStatus(let userID, let targetUserID):
      return .requestParameters(parameters: ["userId":userID, "targetUserId":targetUserID], encoding: URLEncoding.queryString)
    case .blockUser(let userID, let targetUserID):
      return .requestParameters(parameters: ["userId":userID, "targetUserId":targetUserID], encoding: JSONEncoding.default)
    case .unblockUser(let userID, let targetUserID):
      return .requestParameters(parameters: ["userId":userID, "targetUserId":targetUserID], encoding: JSONEncoding.default)
    case .editProfile(_, let backgroundUrl, let profileUrl, let profileName, let profileDescription, let nickname):
      return .requestParameters(parameters: [
        "backgroundUrl": backgroundUrl,
        "profileUrl": profileUrl,
        "profileName": profileName,
        "profileDescription": profileDescription,
        "nickname": nickname
      ], encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
}

