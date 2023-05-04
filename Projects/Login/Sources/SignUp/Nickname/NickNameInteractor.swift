//
//  NickNameInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import RxSwift
import RxRelay
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
  
  // MARK: - Stream
  var isEnableNickname: PublishSubject<Bool> = .init()
  
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
  
  func checkNickname(nickName: String) {
    // 1. 네트워크 통신
    // 2. 받아온 결과 값으로 presenter로 VC에 값 전달
    // 3. 다음 버튼 클릭 시 00에 닉네임 저장해야함 -> attach로직에 들어가야 함.(pushGenderVC)
    
    isEnableNickname.onNext(nickName != "test")
  }
  
}
