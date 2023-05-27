//
//  UserProfileRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/27.
//

import Entity

import Moya
import Foundation

public protocol UserProfileRepository {
  func userPostings(id: Int, userID: Int, createdAt: Int) async -> [PostingDTO]?
}

public class UserProfileRepositoryImpl: BaseRepository, UserProfileRepository {
  public init() {}
  
  let provider = Providers<UserProfileAPI>.make()
  
  public func userPostings(id: Int, userID: Int, createdAt: Int) async -> [PostingDTO]? {
    await provider.request(.userPostings(id, userID, createdAt))
  }
}
