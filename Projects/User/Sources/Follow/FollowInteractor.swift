//
//  FollowInteractor.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Util
import Entity

import RIBs
import RxSwift
import RxRelay

public enum FollowTabType {
  case Follower
  case Following
}

public protocol FollowRouting: ViewableRouting {
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO)
  func detachTargetUserProfileVC(with popType: PopType)
}

protocol FollowPresentable: Presentable {
  var listener: FollowPresentableListener? { get set }
  func setNavTitle(with title: String)
  func setFirstFollowStatus(with tabType: FollowTabType)
}

public protocol FollowListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func detachFollowVC(with popType: PopType)
}

final class FollowInteractor: PresentableInteractor<FollowPresentable>, FollowInteractable, FollowPresentableListener {
  
  weak var router: FollowRouting?
  weak var listener: FollowListener?
  
  var currentFollowTab: BehaviorRelay<FollowTabType> = .init(value: .Follower)
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let userManager: MutableUserManagerStream
  private let targetUserNickname: String
  private let firstFollowTabStatus: FollowTabType
  
  init(
    presenter: FollowPresentable,
    userManager: MutableUserManagerStream,
    targetUserNickname: String,
    firstFollowTabStatus: FollowTabType
  ) {
    self.userManager = userManager
    self.targetUserNickname = targetUserNickname
    self.firstFollowTabStatus = firstFollowTabStatus
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.presenter.setNavTitle(with: targetUserNickname)
    self.presenter.setFirstFollowStatus(with: firstFollowTabStatus)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO) {
    router?.attachTargetUserProfileVC(with: targetUserInfo)
  }
  
  func popTargetUserProfileVC(with popType: Util.PopType) {
    router?.detachTargetUserProfileVC(with: popType)
  }
  
  func popFollowVC(with popType: PopType) {
    self.listener?.detachFollowVC(with: popType)
  }
}
