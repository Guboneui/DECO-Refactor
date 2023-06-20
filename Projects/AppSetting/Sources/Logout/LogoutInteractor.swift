//
//  LogoutInteractor.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/20.
//

import RIBs
import RxSwift

protocol LogoutRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LogoutPresentable: Presentable {
  var listener: LogoutPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LogoutListener: AnyObject {
  func dismissLogoutPopup()
}

final class LogoutInteractor: PresentableInteractor<LogoutPresentable>, LogoutInteractable, LogoutPresentableListener {
  
  weak var router: LogoutRouting?
  weak var listener: LogoutListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: LogoutPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissLogoutPopup() {
    listener?.dismissLogoutPopup()
  }
}
