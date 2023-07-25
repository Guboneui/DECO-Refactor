//
//  CommentDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/07/26.
//

import Foundation

public struct CommentDTO: Codable {
  public let postingReply: PostingCommentDTO
  public let profileUrl: String
  public let nickname: String
  public let replyCount: Int
}

public struct PostingCommentDTO: Codable {
  public let id: Int
  public let userId: Int
  public let postingId: Int
  public let reply: String
  public let parentReplyId: Int
  public let createdAt: Int
  public let replyCount: Int
}
