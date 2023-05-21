//
//  BrandDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/22.
//

import Foundation

public struct BrandDTO: Codable {
  public let description: String
  public let id: Int
  public let imageUrl: String
  public let isKnown: Bool
  public let itemCount: Int
  public let known: Bool
  public let name: String
  public let status: String
}
