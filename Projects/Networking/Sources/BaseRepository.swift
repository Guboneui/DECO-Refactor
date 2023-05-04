//
//  BaseRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Foundation
import Moya

protocol BaseRepository {
  associatedtype apiProvider: TargetType
  var provider: MoyaProvider<apiProvider> { get }
}

fileprivate class Plugins {
  static let logPlugin = NetworkLogPlugin()
}

public class Providers<T: TargetType> {
  static func make() -> MoyaProvider<T> {
    let plugins: [PluginType] = [Plugins.logPlugin]
    return MoyaProvider<T>(plugins: plugins)
  }
}
