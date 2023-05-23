//
//  PostingDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/23.
//

import Foundation

public struct PostingDTO: Codable {
  public var id: Int?
  public var width: Int?
  public var height: Int?
  public var xdpi: Double?
  public var ydpi: Double?
  public var dp: Int?
  public var imageUrl: String?
  public var userId: Int?
  public var userName: String?
  public var createdAt: Int?
  public var likeCount: Int?
  public var likeSort: Int?
  public var replyCount: Int?
  public var profileName: String?
  public var profileUrl: String?
  public var scrap: Bool?
  public var follow: Bool?
  public var colorIds: [Int]
  public var styleId: Int?
  public var boardCategoryId: Int?
  public var postingKeywords: [String]?
  public var postingTextObjectViews: [PostingTextObjectView]
  public var postingBrandObjectViews: [PostingBrandObjectView]
  public var postingProductObjectViews: [PostingProductObjectView]
  public var like: Bool?
}

public struct PostingTextObjectView: Codable {
  public var postingText: PostingText
  public var translationX: Double?
  public var translationY: Double?
  public var scaleX: Double?
  public var scaleY: Double?
  public var rotation: Double?
  public var direction: String?
  public var ordinal: Int?
}

public struct PostingText: Codable {
  public var textColor: PostingColor?
  public var backgroundColor: PostingColor?
  public var gravity: String?
  public var text: String?
}

public struct PostingColor: Codable {
  public var colors: [Int]
  public var id: Int?
  public var name: String?
}

public struct PostingBrandObjectView: Codable {
  public var postingBrand: PostingBrand?
  public var known: Bool?
  public var translationX: Double?
  public var translationY: Double?
  public var direction: String?
  public var ordinal: Int?
}

public struct PostingBrand: Codable {
  public var id: Int?
  public var name: String?
  public var imageUrl: String?
  public var status: String?
}


public struct PostingProductObjectView: Codable {
  public var postingProduct: PostingProduct?
  public var translationX: Double?
  public var translationY: Double?
  public var direction: String?
  public var ordinal: Int?
}

public struct PostingProduct: Codable {
  public var id: Int?
  public var name: String?
  public var brandName: String?
  public var imageUrl: String?
  public var status: String?
}
