//
//  AppSettingInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/27.
//

import Util

import RIBs
import RxSwift

public protocol AppSettingRouting: ViewableRouting {
  func attachLogoutPopupVC()
  func detachLogoutPopupVC()
}

protocol AppSettingPresentable: Presentable {
  var listener: AppSettingPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol AppSettingListener: AnyObject {
  func detachAppSettingVC(with popType: PopType)
}

final class AppSettingInteractor: PresentableInteractor<AppSettingPresentable>, AppSettingInteractable, AppSettingPresentableListener {
  
  weak var router: AppSettingRouting?
  weak var listener: AppSettingListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: AppSettingPresentable) {
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
  
  func popAppSettingVC(with popType: Util.PopType) {
    self.listener?.detachAppSettingVC(with: popType)
  }
  
  func showLogoutPopup() {
    self.router?.attachLogoutPopupVC()
  }
  
  func dismissLogoutPopup() {
    self.router?.detachLogoutPopupVC()
  }
}
