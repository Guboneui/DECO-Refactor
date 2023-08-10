//
//  FeedTextObjectBackgroundColor.swift
//  CommonUI
//
//  Created by 구본의 on 2023/08/10.
//

import UIKit

public struct FeedBackgroundColorModel {
  let id: Int
  let backgroundColor: UIColor
  let textColor: UIColor
  let textColorId: Int
}

public struct FeedBackgroundColor {
  public let feedBackgroundColor: [Int: FeedBackgroundColorModel] = [
    0: FeedBackgroundColorModel(id: 0, backgroundColor: .clear, textColor: .white, textColorId: 0),
    1: FeedBackgroundColorModel(id: 1, backgroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0), textColor: .white, textColorId: 0),
    2: FeedBackgroundColorModel(id: 2, backgroundColor: UIColor(red: 254/255, green: 255/255, blue: 254/255, alpha: 1.0), textColor: UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1.0), textColorId: 0),
    3: FeedBackgroundColorModel(id: 3, backgroundColor: UIColor(red: 252/255, green: 13/255, blue: 0/255, alpha: 1.0), textColor: .white, textColorId: 0),
    4: FeedBackgroundColorModel(id: 4, backgroundColor: UIColor(red: 254/255, green: 133/255, blue: 183/255, alpha: 1.0), textColor: .white, textColorId: 0),
    5: FeedBackgroundColorModel(id: 5, backgroundColor: UIColor(red: 175/255, green: 124/255, blue: 198/255, alpha: 1.0), textColor: .white, textColorId: 0),
    6: FeedBackgroundColorModel(id: 6, backgroundColor: UIColor(red: 131/255, green: 0/255, blue: 213/255, alpha: 1.0), textColor: .white, textColorId: 0),
    7: FeedBackgroundColorModel(id: 7, backgroundColor: UIColor(red: 88/255, green: 105/255, blue: 250/255, alpha: 1.0), textColor: .white, textColorId: 0),
    8: FeedBackgroundColorModel(id: 8, backgroundColor: UIColor(red: 60/255, green: 64/255, blue: 216/255, alpha: 1.0), textColor: .white, textColorId: 0),
    9: FeedBackgroundColorModel(id: 9, backgroundColor: UIColor(red: 49/255, green: 0/255, blue: 124/255, alpha: 1.0), textColor: .white, textColorId: 0),
    10: FeedBackgroundColorModel(id: 10, backgroundColor: UIColor(red: 79/255, green: 253/255, blue: 176/255, alpha: 1.0), textColor: .black, textColorId: 1),
    11: FeedBackgroundColorModel(id: 11, backgroundColor: UIColor(red: 0/255, green: 207/255, blue: 81/255, alpha: 1.0), textColor: .black, textColorId: 1),
    12: FeedBackgroundColorModel(id: 12, backgroundColor: UIColor(red: 250/255, green: 251/255, blue: 80/255, alpha: 1.0), textColor: .black, textColorId: 1),
    13: FeedBackgroundColorModel(id: 13, backgroundColor: UIColor(red: 251/255, green: 156/255, blue: 33/255, alpha: 1.0), textColor: .white, textColorId: 0),
    14: FeedBackgroundColorModel(id: 14, backgroundColor: UIColor(red: 240/255, green: 164/255, blue: 139/255, alpha: 1.0), textColor: .black, textColorId: 1),
    15: FeedBackgroundColorModel(id: 15, backgroundColor: UIColor(red: 173/255, green: 108/255, blue: 55/255, alpha: 1.0), textColor: .white, textColorId: 0),
    16: FeedBackgroundColorModel(id: 16, backgroundColor: UIColor(red: 128/255, green: 48/255, blue: 31/255, alpha: 1.0), textColor: .white, textColorId: 0),
    17: FeedBackgroundColorModel(id: 17, backgroundColor: UIColor(red: 67/255, green: 97/255, blue: 84/255, alpha: 1.0), textColor: .white, textColorId: 0),
    18: FeedBackgroundColorModel(id: 18, backgroundColor: UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0), textColor: .white, textColorId: 0),
    19: FeedBackgroundColorModel(id: 19, backgroundColor: UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0), textColor: UIColor(red: 36/255, green: 36/255, blue: 36/255, alpha: 1.0), textColorId: 1)
  ]
  
  public func getFeedBackgroundColor(colorID: Int) -> FeedBackgroundColorModel {
    guard let backgroundColor = feedBackgroundColor[colorID] else {
      return FeedBackgroundColorModel(id: 0, backgroundColor: .clear, textColor: .white, textColorId: 1)
    }
    return backgroundColor
  }
}
