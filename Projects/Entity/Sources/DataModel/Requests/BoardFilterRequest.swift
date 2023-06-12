//
//  BoardFilterRequest.swift
//  Entity
//
//  Created by 구본의 on 2023/06/13.
//

import Foundation

public struct BoardFilterRequest: Codable {
  public let offset: Int
  public let listType: String
  public let keyword: String?
  public let styleIds: [Int]
  public let colorIds: [Int]
  public let boardCategoryIds: [Int]
  public let userId: Int
  
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
