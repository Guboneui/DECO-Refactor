//
//  UserDTO.swift
//  Entity
//
//  Created by 구본의 on 2023/05/30.
//

import Foundation

public struct UserDTO: Codable {
  public let profileUrl: String
  public let followStatus: Bool
  public let nickName: String
  public let userId: Int
  public let profileName: String
}
