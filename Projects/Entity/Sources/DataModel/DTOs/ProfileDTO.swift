//
//  ProfileDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/27.
//

import Foundation

public struct ProfileDTO: Codable {
  public let nickname: String
  public let profileUrl: String
  public let backgroundUrl: String
  public let profileDescription: String
  public let profileName: String
  public let followCount: Int
  public let followingCount: Int
  public let boardCount: Int
  public let userId: Int
  public let followStatus: Bool
}

