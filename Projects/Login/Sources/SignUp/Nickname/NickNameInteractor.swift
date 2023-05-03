//
//  NickNameInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import RxSwift
import Util

protocol NickNameRouting: ViewableRouting {

}

protocol NickNamePresentable: Presentable {
  var listener: NickNamePresentableListener? { get set }
}

protocol NickNameListener: AnyObject {
  func detachNicknameVC(with popType: PopType)
  func attachGenderVC()
}

final class NickNameInteractor:
  PresentableInteractor<NickNamePresentable>,
  NickNameInteractable,
  NickNamePresentableListener
{
  
  weak var router: NickNameRouting?
  weak var listener: NickNameListener?
  
  override init(presenter: NickNamePresentable) {
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
  
}
