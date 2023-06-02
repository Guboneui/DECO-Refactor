//
//  ItemFilterRequest.swift
//  Entity
//
//  Created by 구본의 on 2023/06/02.
//

import Foundation

public struct ItemFilterRequest: Codable {
  public let userId: Int
  public let itemCategoryIds: [Int]
  public let colorIds: [Int]
  public let styleIds: [Int]
  public let createdAt: Int
  public let name: String
  
  public init(
    userId: Int,
    itemCategoryIds: [Int],
    colorIds: [Int],
    styleIds: [Int],
    createdAt: Int,
    name: String
  ) {
    self.userId = userId
    self.itemCategoryIds = itemCategoryIds
    self.colorIds = colorIds
    self.styleIds = styleIds
    self.createdAt = createdAt
    self.name = name
  }
}
