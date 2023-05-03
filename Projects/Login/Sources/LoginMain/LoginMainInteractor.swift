//
//  LoginMainInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import RxSwift
import Util
import UIKit

enum LoginType {
  case KAKAO
  case NAVER
  case GOOGLE
  case APPLE
}

public protocol LoginMainRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
  func attachNicknameVC()
  func detachNicknameVC(with popType: PopType)
  
  func attachGenderVC()
  func detachGenderVC(with popType: PopType)
  
  func attachAgeVC()
  func detachAgeVC(with popType: PopType)
  
  func attachMoodVC()
  func detachMoodVC(with popType: PopType)
}

protocol LoginMainPresentable: Presentable {
  var listener: LoginMainPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol LoginMainListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoginMainInteractor:
  PresentableInteractor<LoginMainPresentable>,
  LoginMainInteractable,
  LoginMainPresentableListener
{

  weak var router: LoginMainRouting?
  weak var listener: LoginMainListener?
  
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: LoginMainPresentable) {
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
  
  func pushNicknameVC(by loginType: LoginType) {
    router?.attachNicknameVC()
  }
  
  func detachNicknameVC(with popType: PopType) {
    router?.detachNicknameVC(with: popType)
  }
  
  func attachGenderVC() {
    router?.attachGenderVC()
  }
  
  func detachGenderVC(with popType: PopType) {
    router?.detachGenderVC(with: popType)
  }
  
  func attachAgeVC() {
    router?.attachAgeVC()
  }
  
  func detachAgeVC(with popType: PopType) {
    router?.detachAgeVC(with: popType)
  }
  
  func attachMoodVC() {
    router?.attachMoodVC()
  }
  
  func detachMoodVC(with popType: PopType) {
    router?.detachMoodVC(with: popType)
  }
}
