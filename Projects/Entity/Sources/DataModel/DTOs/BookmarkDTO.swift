//
//  BookmarkDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/29.
//

import Foundation

public struct BookmarkDTO: Codable {
  public let scrap: Bookmark
  public let imageUrl: String
  public let postingView: PostingDTO?
}

public struct Bookmark: Codable {
  public let id: Int
  public let productId: Int
  public let boardId: Int
  public let userId: Int
  public let createdAt: Int
}
