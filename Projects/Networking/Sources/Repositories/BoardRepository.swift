//
//  BoardRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/29.
//

import Entity

import Moya
import Foundation

public protocol BoardRepository {
  func boardCategoryList() async -> [BoardCategoryDTO]?
}

public class BoardRepositoryImpl: BaseRepository, BoardRepository {
  public init() {}
  
  let provider = Providers<BoardAPI>.make()
  
  public func boardCategoryList() async -> [BoardCategoryDTO]? {
    await provider.request(.boardCategoryList)
  }
}


