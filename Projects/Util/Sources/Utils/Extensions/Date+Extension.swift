//
//  Date+Extension.swift
//  Util
//
//  Created by 구본의 on 2023/07/20.
//

import Foundation

public extension Date {
  
  func getTimeInterver(serverTime: Int) -> String {
    let currentTime = Int((Date().timeIntervalSince1970) * 1000)
    let formatter = RelativeDateTimeFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateTimeStyle = .numeric
    formatter.unitsStyle = .short
    
    let interver = (serverTime - currentTime) / 1000
    let time = Date(timeInterval: Double(interver), since: Date())
    let timeInterver = formatter.localizedString(for: time, relativeTo: Date())
    
    return timeInterver
  }
}

