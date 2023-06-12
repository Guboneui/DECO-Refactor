//
//  SearchUserDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/06/13.
//

public struct SearchUserDTO: Codable {
  public let imageUrl: String
  public let profileName: String
  public let user: SearchUserInfo
  
  init(imageUrl: String, profileName: String, user: SearchUserInfo) {
    self.imageUrl = imageUrl
    self.profileName = profileName
    self.user = user
  }
}

public struct SearchUserInfo: Codable {
  public var id: Int
  public var loginType: String
  public var email: String
  public var nickname: String
  public var birthYear: Int
  public var birthMonth: Int
  public var birthDay: Int
  public var gender: String
  public var createdAt: Int
  public var loginAt: Int?
  public var followCount: Int
  public var followingCount: Int
  public var boardCount: Int
  public var status: String
}

