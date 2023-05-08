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
  func moveToMainRIB()
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
  private let userSignUpInfoStream: MutableSignUpStream
  
  init(
    presenter: LoginMainPresentable,
    dependency: LoginMainInteractorDependency,
    userSignUpInfoStream: MutableSignUpStream
  ) {
    self.dependency = dependency
    self.userSignUpInfoStream = userSignUpInfoStream
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  // MARK: - LoginMainPresentableListener Method
  func pushNicknameVC(by loginType: LoginType) {
    router?.attachNicknameVC()
  }

  // MARK: - NickNameListener Method
  func detachNicknameVC(with popType: PopType) {
    router?.detachNicknameVC(with: popType)
  }
  
  func nicknameDidChecked(withNickname nickname: String) {
    userSignUpInfoStream.updateNickname(nickname: nickname)
  }
  
  func moveToMain() {
    listener?.moveToMainRIB()
  }
}
