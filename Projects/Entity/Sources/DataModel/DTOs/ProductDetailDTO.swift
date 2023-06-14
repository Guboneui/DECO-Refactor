//
//  ProductDetailDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/06/14.
//

import Foundation

public struct ProductDetailDTO: Codable {
  public let product: ProductDetail
  public let brandName: String
  public let scrap: Bool
  
  public enum CodingKeys: String, CodingKey {
    case product = "item"
    case brandName, scrap
  }
}

public struct ProductDetail: Codable {
  public let id: Int
  public let name: String
  public let brandId: Int
  public let imageUrl: String
  public let vendorName: String
  public let soldOut: Bool
  public let sellLink: String?
  public let category_id: Int
  public let createdAt: Int
  public let updatedAt: Int
  public let price: Int
  public let status: String
}
