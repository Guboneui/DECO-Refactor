//
//  APIMapper.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Foundation
import Moya

extension MoyaProvider {
  func request<T: Codable>(_ t: Target) async -> T? {
    await withCheckedContinuation({ continuation in
      request(t, completion: { result in
        switch result {
        case let .success(response):
          switch response.statusCode {
          case 200...399:
            do {
              continuation.resume(returning: try response.map(T.self))
            } catch {
              continuation.resume(returning: nil)
            }
          default:
            _ = handleError(response.statusCode)
            continuation.resume(returning: nil)
          }
        case let .failure(error):
          _ = handleError(error: error)
          continuation.resume(returning: nil)
        }
      })
    })
  }
}
