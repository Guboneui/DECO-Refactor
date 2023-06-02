//
//  ProductDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/06/02.
//

import Foundation

public struct ProductDTO: Codable {
  public let name: String
  public let imageUrl: String
  public let brandName: String
  public let id: Int
  public let scrap: Bool
  public let createdAt: Int
  
  public init(
    name: String,
    imageUrl: String,
    brandName: String,
    id: Int,
    scrap: Bool,
    createdAt: Int
  ) {
    self.name = name
    self.imageUrl = imageUrl
    self.brandName = brandName
    self.id = id
    self.scrap = scrap
    self.createdAt = createdAt
  }
}
