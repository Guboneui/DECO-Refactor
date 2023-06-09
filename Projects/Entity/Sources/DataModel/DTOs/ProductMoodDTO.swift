//
//  ProductMoodDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/16.
//

import Foundation

public struct ProductMoodDTO: Codable {
  public let id: Int
  public let url: String
  public let name: String
  
  public init(id: Int, url: String, name: String) {
    self.id = id
    self.url = url
    self.name = name
  }
}
