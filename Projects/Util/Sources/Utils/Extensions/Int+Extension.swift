//
//  Int+Extension.swift
//  Util
//
//  Created by 구본의 on 2023/06/14.
//

import Foundation

public extension Int {
  func numberFormatter() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value: self))!
  }
}
