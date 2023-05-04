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
import Networking

enum LoginType {
  case KAKAO
  case NAVER
  case GOOGLE
  case APPLE
}

public protocol LoginMainRouting: ViewableRouting {
  func attachNicknameVC()
  func detachNicknameVC(with popType: PopType)
}

protocol LoginMainPresentable: Presentable {
  var listener: LoginMainPresentableListener? { get set }
}

public protocol LoginMainListener: AnyObject {

}

public protocol LoginMainInteractorDependency {
  var userControlRepository: UserControlRepositoryImpl { get }
}

final class LoginMainInteractor:
  PresentableInteractor<LoginMainPresentable>,
  LoginMainInteractable,
  LoginMainPresentableListener
{
  weak var router: LoginMainRouting?
  weak var listener: LoginMainListener?
  
  private let dependency: LoginMainInteractorDependency
  
  init(
    presenter: LoginMainPresentable,
    dependency: LoginMainInteractorDependency
  ) {
    self.dependency = dependency
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()

  }
  
  override func willResignActive() {
    super.willResignActive()

  }
  
  func pushNicknameVC(by loginType: LoginType) {
    router?.attachNicknameVC()
  }

  func detachNicknameVC(with popType: PopType) {
    router?.detachNicknameVC(with: popType)
  }
}
