//
//  ProductCategoryDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/16.
//

import Foundation

public struct ProductCategoryDTO: Codable {
  public let categoryName: String
  public let id: Int
  
  public init(categoryName: String, id: Int) {
    self.categoryName = categoryName
    self.id = id
  }
}
