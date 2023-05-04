//
//  UserControlRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Moya
import Foundation

protocol UserControlRepository {
  func checkNickname(nickname: String) async -> Bool?
}

public class UserControlRepositoryImpl: BaseRepository, UserControlRepository {
  public init() {}
  
  let provider = Providers<UserControlAPI>.make()
  
  public func checkNickname(nickname: String) async -> Bool? {
    await provider.request(.checkNickname(nickname: nickname))
  }
}
