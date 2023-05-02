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
  func detachNicknameVC()
  
  func attachGenderVC()
  func detachGenderVC()
  
  func attachAgeVC()
  func detachAgeVC()
  
  func attachMoodVC()
  func detachMoodVC()
  
  func test()
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
  LoginMainPresentableListener, NavigationControllerDelegate
{
  
  
  
  weak var router: LoginMainRouting?
  weak var listener: LoginMainListener?
  
  let navigationControllerDelegateProxy: NavigationControllerDelegateProxy
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: LoginMainPresentable) {
    self.navigationControllerDelegateProxy = NavigationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.navigationControllerDelegateProxy.delegate = self
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
    print("🔊[DEBUG]: Interactor")
  }
  
  func detachNicknameVC() {
    router?.detachNicknameVC()
  }
  
  func attachGenderVC() {
    router?.attachGenderVC()
  }
  
  func detachGenderVC() {
    router?.detachGenderVC()
  }
  
  func attachAgeVC() {
    router?.attachAgeVC()
  }
  
  func detachAgeVC() {
    router?.detachAgeVC()
  }
  
  func attachMoodVC() {
    router?.attachMoodVC()
  }
  
  func detachMoodVC() {
    router?.detachMoodVC()
  }
  
  func navigationController() {
    print("zzzzzzz")
    router?.detachNicknameVC()
  }
  
}
