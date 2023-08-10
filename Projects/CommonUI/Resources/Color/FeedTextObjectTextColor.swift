//
//  FeedTextObjectTextColor.swift
//  CommonUI
//
//  Created by 구본의 on 2023/08/10.
//

import UIKit

public struct FeedTextColorModel {
  let id: Int
  let color: UIColor
}

public struct FeedTextColor {
  public let feedTextColor: [Int: FeedTextColorModel] = [
    0: FeedTextColorModel(id: 0, color: UIColor(red: 254/255, green: 255/255, blue: 254/255, alpha: 1.0)),
    1: FeedTextColorModel(id: 1, color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)),
    2: FeedTextColorModel(id: 2, color: UIColor(red: 252/255, green: 13/255, blue: 0/255, alpha: 1.0)),
    3: FeedTextColorModel(id: 3, color: UIColor(red: 254/255, green: 133/255, blue: 183/255, alpha: 1.0)),
    4: FeedTextColorModel(id: 4, color: UIColor(red: 175/255, green: 124/255, blue: 198/255, alpha: 1.0)),
    5: FeedTextColorModel(id: 5, color: UIColor(red: 131/255, green: 0/255, blue: 213/255, alpha: 1.0)),
    6: FeedTextColorModel(id: 6, color: UIColor(red: 88/255, green: 105/255, blue: 250/255, alpha: 1.0)),
    7: FeedTextColorModel(id: 7, color: UIColor(red: 60/255, green: 64/255, blue: 216/255, alpha: 1.0)),
    8: FeedTextColorModel(id: 8, color: UIColor(red: 49/255, green: 0/255, blue: 124/255, alpha: 1.0)),
    9: FeedTextColorModel(id: 9, color: UIColor(red: 79/255, green: 253/255, blue: 176/255, alpha: 1.0)),
    10: FeedTextColorModel(id: 10, color: UIColor(red: 0/255, green: 207/255, blue: 81/255, alpha: 1.0)),
    11: FeedTextColorModel(id: 11, color: UIColor(red: 250/255, green: 251/255, blue: 80/255, alpha: 1.0)),
    12: FeedTextColorModel(id: 12, color: UIColor(red: 251/255, green: 156/255, blue: 33/255, alpha: 1.0)),
    13: FeedTextColorModel(id: 13, color: UIColor(red: 240/255, green: 164/255, blue: 139/255, alpha: 1.0)),
    14: FeedTextColorModel(id: 14, color: UIColor(red: 173/255, green: 108/255, blue: 55/255, alpha: 1.0)),
    15: FeedTextColorModel(id: 15, color: UIColor(red: 128/255, green: 48/255, blue: 31/255, alpha: 1.0)),
    16: FeedTextColorModel(id: 16, color: UIColor(red: 67/255, green: 97/255, blue: 84/255, alpha: 1.0)),
    17: FeedTextColorModel(id: 17, color: UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)),
    18: FeedTextColorModel(id: 18, color: UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1.0)),
    19: FeedTextColorModel(id: 19, color: UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0))
  ]

  public func getFeedTextColor(colorID: Int) -> FeedTextColorModel {
    guard let textColor = feedTextColor[colorID] else {
      return FeedTextColorModel(id: 0, color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0))
    }
    return textColor
  }
}
