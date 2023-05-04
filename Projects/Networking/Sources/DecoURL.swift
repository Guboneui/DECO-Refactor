//
//  DecoURL.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Foundation

enum DecoURL {
  enum API {
    static let urlString = "http://52.86.103.179:8080"
    
    static var url: URL {
      guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
      return url
    }
  }
}
