//
//  UserDefaults+Extension.swift
//  Util
//
//  Created by 구본의 on 2023/07/28.
//

import Foundation

public enum UserDefaultsKey: String {
  case searchHistory
}

public extension UserDefaults {
  func updateSearchHistoryValue(with searchHistory: String) {
    let key: String = UserDefaultsKey.searchHistory.rawValue
    let defaults = UserDefaults.standard
    var historyValue = getSearchHistoryValue()
    
    if historyValue.isEmpty {
      defaults.set([searchHistory], forKey: key)
    } else {
      historyValue.append(searchHistory)
      defaults.set(historyValue, forKey: key)
    }
  }
  
  func getSearchHistoryValue() -> [String] {
    let key: String = UserDefaultsKey.searchHistory.rawValue
    let defaults = UserDefaults.standard
    let historyValue: [String] = defaults.array(forKey: key) as? [String] ?? []
    return historyValue
  }
}
