//
//  Encodable+Extension.swift
//  Entity
//
//  Created by 구본의 on 2023/06/02.
//

import Foundation

public extension Encodable {
  var toDictionary: [String: Any] {
    guard let object = try? JSONEncoder().encode(self) else { return [:] }
    guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return [:] }
    return dictionary
  }
}
