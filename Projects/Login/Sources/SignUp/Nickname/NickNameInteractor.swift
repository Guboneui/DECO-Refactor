//
//  NickNameInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import Foundation
import RIBs
import RxSwift
import RxRelay
import Util
import Networking

protocol NickNameRouting: ViewableRouting {

}

protocol NickNamePresentable: Presentable {
  var listener: NickNamePresentableListener? { get set }
}

protocol NickNameListener: AnyObject {
  func detachNicknameVC(with popType: PopType)
  func attachGenderVC()
}

protocol NicknameInteractorDependency {
  var userControlRepository: UserControlRepositoryImpl { get }
}

final class NickNameInteractor:
  PresentableInteractor<NickNamePresentable>,
  NickNameInteractable,
  NickNamePresentableListener
{
  
  weak var router: NickNameRouting?
  weak var listener: NickNameListener?
  
  private var dependency: NicknameInteractorDependency
  
  // MARK: - Stream
  var isEnableNickname: PublishSubject<Bool> = .init()
  
  init(
    presenter: NickNamePresentable,
    dependency: NicknameInteractorDependency
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
  
  func popNicknameVC(with popType: PopType) {
    listener?.detachNicknameVC(with: popType)
  }
  
  func pushGenderVC() {
    listener?.attachGenderVC()
  }
  
  func checkNickname(nickName: String) {
    Task { [weak self] in
      guard let self else { return }
      if let isEnable = await self.dependency.userControlRepository.checkNickname(nickname: nickName) {
        self.isEnableNickname.onNext(!isEnable)
      }
    }
  }
}
