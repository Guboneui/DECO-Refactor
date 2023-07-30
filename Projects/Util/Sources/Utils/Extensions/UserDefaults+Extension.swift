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
      if let targetIndex: Int = historyValue.lastIndex(of: searchHistory) {
        let popValue: String = historyValue.remove(at: targetIndex)
        historyValue.insert(popValue, at: 0)
      } else {
        historyValue.insert(searchHistory, at: 0)
      }
      if historyValue.count > 5 {
        historyValue.removeLast()
      }
      defaults.set(historyValue, forKey: key)
    }
  }
  
  func removeAllSearchHistory() {
    let key: String = UserDefaultsKey.searchHistory.rawValue
    let defaults = UserDefaults.standard
    
    defaults.set([String](), forKey: key)
  }
  
  func getSearchHistoryValue() -> [String] {
    let key: String = UserDefaultsKey.searchHistory.rawValue
    let defaults = UserDefaults.standard
    let historyValue: [String] = defaults.array(forKey: key) as? [String] ?? []
    return historyValue
  }
}
