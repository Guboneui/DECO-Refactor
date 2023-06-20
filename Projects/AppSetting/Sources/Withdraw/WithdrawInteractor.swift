//
//  WithdrawInteractor.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/21.
//

import Networking

import RIBs
import RxSwift
import RxRelay

protocol WithdrawRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WithdrawPresentable: Presentable {
  var listener: WithdrawPresentableListener? { get set }
  @MainActor func setCvHeight(with count: Int)
}

protocol WithdrawListener: AnyObject {
  func dismissWithdrawPopup()
}

final class WithdrawInteractor: PresentableInteractor<WithdrawPresentable>, WithdrawInteractable, WithdrawPresentableListener {
  
  weak var router: WithdrawRouting?
  weak var listener: WithdrawListener?
  
  private let withdrawRepository: WithdrawRepository
  
  var withdrawReason: BehaviorRelay<[String]> = .init(value: [])
  
  init(
    presenter: WithdrawPresentable,
    withdrawRepository: WithdrawRepository
  ) {
    self.withdrawRepository = withdrawRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    Task.detached { [weak self] in
      guard let self else { return }
      await self.fetchWithdrawReason()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissWithdrawPopup() {
    self.listener?.dismissWithdrawPopup()
  }
  
  private func fetchWithdrawReason() async {
    if let reason = await self.withdrawRepository.getWithdrawReason() {
      self.withdrawReason.accept(reason)
      await self.presenter.setCvHeight(with: reason.count)
    }
  }
}
