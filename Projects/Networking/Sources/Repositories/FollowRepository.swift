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
}

