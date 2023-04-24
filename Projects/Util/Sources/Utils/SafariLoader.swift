//
//  SafariLoader.swift
//  Util
//
//  Created by 구본의 on 2023/04/24.
//  Copyright © 2023 Boni. All rights reserved.
//

import UIKit

protocol SafariLoader {
  static func loadSafari(with url: String)
}

public struct SafariLoderImpl: SafariLoader {
  public static func loadSafari(with url: String) {
    if let url = URL(string: url) {
      UIApplication.shared.open(url)
    }
  }
}
