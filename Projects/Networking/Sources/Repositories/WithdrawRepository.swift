//
//  WithdrawRepository.swift
//  Networking
//
//  Created by 구본의 on 2023/06/21.
//

import Foundation
import Moya
import Entity

public protocol WithdrawRepository {
  func getWithdrawReason() async -> [String]?
}

public class WithdrawRepositoryImpl: BaseRepository, WithdrawRepository {
  
  public init() {}
  
  let provider = Providers<WithdrawAPI>.make()
  
  public func getWithdrawReason() async -> [String]? {
    await provider.request(.withdrawReason)
  }
}


