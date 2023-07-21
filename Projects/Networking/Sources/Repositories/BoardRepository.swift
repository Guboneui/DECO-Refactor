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
  func boardList(param: BoardRequestDTO) async -> [PostingDTO]?
  func boardInfo(boardID: Int, userID: Int) async -> PostingDTO?
  func boardLike(boardID: Int, userID: Int) async -> Bool?
  func boardDisLike(boardID: Int, userID: Int) async -> Bool?
  
}

public class BoardRepositoryImpl: BaseRepository, BoardRepository {
  public init() {}
  
  let provider = Providers<BoardAPI>.make()
  
  public func boardCategoryList() async -> [BoardCategoryDTO]? {
    await provider.request(.boardCategoryList)
  }
  
  public func boardList(param: BoardRequestDTO) async -> [PostingDTO]? {
    await provider.request(.boardList(param))
  }
  
  public func boardInfo(boardID: Int, userID: Int) async -> PostingDTO? {
    await provider.request(.boardInfo(boardID, userID))
  }
  
  public func boardLike(boardID: Int, userID: Int) async -> Bool? {
    await provider.request(.boardLike(boardID, userID))
  }
  
  public func boardDisLike(boardID: Int, userID: Int) async -> Bool? {
    await provider.request(.boardDisLike(boardID, userID))
  }
}


