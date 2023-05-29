//
//  BookmarkRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/29.
//

import Entity

import Moya
import Foundation

public protocol BookmarkRepository {
  func bookmarkList(userId: Int, scrapType: String, itemCategoryId: Int, boardCategoryId:Int, createdAt: Int) async -> [BookmarkDTO]?
}

public class BookmarkRepositoryImpl: BaseRepository, BookmarkRepository {
  
  public init() {}
  
  let provider = Providers<BookmarkAPI>.make()
  
  public func bookmarkList(
    userId: Int,
    scrapType: String,
    itemCategoryId: Int,
    boardCategoryId: Int,
    createdAt: Int
  ) async -> [BookmarkDTO]? {
    await provider.request(.bookmarkList(userId, scrapType, itemCategoryId, boardCategoryId, createdAt))
  }
  
}



