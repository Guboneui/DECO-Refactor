//
//  FollowRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/30.
//

import Foundation

import Entity

import Moya

public protocol FollowRepository {
  func followerList(targetID: Int, userID: Int) async -> [UserDTO]?
  func followingList(targetID: Int, userID: Int, name: String) async -> [UserDTO]?
  func follow(targetID: Int, userID: Int, follow: Bool) async -> Bool?
  func unfollow(targetID: Int, userID: Int, follow: Bool) async -> Bool?
}

public class FollowRepositoryImpl: BaseRepository, FollowRepository {
  public init() {}
  
  let provider = Providers<FollowAPI>.make()
  
  public func followerList(targetID: Int, userID: Int) async -> [UserDTO]? {
    await provider.request(.followerList(targetID, userID))
  }
  
  public func followingList(targetID: Int, userID: Int, name: String) async -> [UserDTO]? {
    await provider.request(.followingList(targetID, userID, name))
  }
  
  public func follow(targetID: Int, userID: Int, follow: Bool) async -> Bool? {
    await provider.request(.follow(targetID, userID, follow))
  }
  
  public func unfollow(targetID: Int, userID: Int, follow: Bool) async -> Bool? {
    await provider.request(.unfollow(targetID, userID, follow))
  }
}

