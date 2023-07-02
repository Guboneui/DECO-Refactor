//
//  BoardRequest.swift
//  Entity
//
//  Created by 구본의 on 2023/07/02.
//

import Foundation

public enum BoardType: String {
  case LATEST
  case LIKE
  case FOLLOW
}

public struct BoardRequestDTO: Codable {
  let offset: Int
  let listType: String
  let keyword: String?
  let styleIds: [Int]
  let colorIds: [Int]
  let boardCategoryIds: [Int]
  let userId: Int
  
  public init(offset: Int, listType: String, keyword: String?, styleIds: [Int], colorIds: [Int], boardCategoryIds: [Int], userId: Int) {
    self.offset = offset
    self.listType = listType
    self.keyword = keyword
    self.styleIds = styleIds
    self.colorIds = colorIds
    self.boardCategoryIds = boardCategoryIds
    self.userId = userId
  }
}
