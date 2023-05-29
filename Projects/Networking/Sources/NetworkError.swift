//
//  NetworkError.swift
//  Networking
//
//  Created by 구본의 on 2023/05/04.
//

import Foundation
import Alamofire
import Moya

enum NetworkError: Error {
  case serviceError(MoyaError)
  case Internal(code: Int)
  case BadRequest
  case UnAuthorized
  case Timeout
}

func handleError(_ statusCode: Int) -> NetworkError {
  switch (statusCode) {
    case 400:
      print("🔴 FAILURE: [400 BADREQUEST ERROR]")
      return NetworkError.BadRequest
    case 401, 403:
      print("🔴 FAILURE: [\(statusCode) UNAUTHORIZED ERROR]")
      return NetworkError.UnAuthorized
    case 500..<599:
      print("🔴 FAILURE: [\(statusCode) INTERNAL ERROR]")
      return NetworkError.Internal(code: statusCode)
    case NSURLErrorTimedOut:
      print("🔴 FAILURE: [\(statusCode), TIMEOUT ERROR]")
      return NetworkError.Timeout
    default:
      print("🔴 FAILURE: [599] 기타 ERROR")
      return NetworkError.Internal(code: 599)
  }
}


func handleError(error: MoyaError) -> NetworkError {
  switch error {
    case .underlying(let afError as AFError, _):
      if let urlError = afError.underlyingError as? URLError {
        return handleError(urlError.errorCode)
      }
      fallthrough
    default:
      return handleError(501)
  }
}
