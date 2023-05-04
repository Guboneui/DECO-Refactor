//
//  NetworkLogPlugIn.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Foundation
import Moya

struct NetworkLogPlugin: PluginType {
  func willSend(_ request: RequestType, target: TargetType) {
    printRequestMessage(from: target)
  }
  
  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    switch result {
    case let .success(response):
      printSuccessMessage(from: response, with: target)
    case let.failure(error):
      printErrorMessage(from: error, with: target)
    }
  }
  
  private func printRequestMessage(from target: TargetType) {
    let requestInfo = self.requestInfo(from: target)
    let message = "▶️ REQUEST: \(requestInfo) \(getCurrentDate())"
    print(message)
  }
  
  private func printSuccessMessage(from response: Response, with target: TargetType) {
    let requestInfo = self.requestInfo(from: target)
    let message = "🟢 SUCCESS: \(requestInfo) (\(response.description))"
    print(message)
  }
  
  private func printErrorMessage(from error: MoyaError, with target: TargetType) {
    let requestInfo = self.requestInfo(from: target)
    let errorDescription = error.errorDescription ?? ""
    let message = "🔴 FAILURE: \(requestInfo) \(errorDescription)"
    print(message)
  }
  
  private func requestInfo(from target: TargetType) -> String {
    let info = "\(target.method.rawValue) \(target.path)"
    return info
  }
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY.MM.dd HH:mm:ss:SSS"
    return formatter
  }()

  private func getCurrentDate() -> String {
    "[\(dateFormatter.string(from: Date()))]"
  }
}

//extension MoyaProvider {
//  func request<T: Codable>(_ t: Target) async throws -> T {
//    try await withCheckedThrowingContinuation({ continuation in
//      request(t) { res in
//        switch res {
//        case let .success(successRes):
//          switch successRes.statusCode {
//          case 200...399:
//            continuation.resume(returning: try! successRes.map(T.self))
//          default:
//            print("Error")
//            continuation.resume(throwing: NetworkError.NetworkError)
//          }
//        case let .failure(errRes):
//          print("Error")
//          continuation.resume(throwing: errRes)
//        }
//      }
//    })
//  }
//
//}
