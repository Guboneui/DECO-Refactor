//
//  FollowerListInteractor.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol FollowerListRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FollowerListPresentable: Presentable {
  var listener: FollowerListPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FollowerListListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FollowerListInteractor: PresentableInteractor<FollowerListPresentable>, FollowerListInteractable, FollowerListPresentableListener {
  
  weak var router: FollowerListRouting?
  weak var listener: FollowerListListener?
  
  var followerList: BehaviorRelay<[UserDTO]> = .init(value: [])
  lazy var userID: Int = userManager.userID
  
  private let userManager: MutableUserManagerStream
  private let followRepository: FollowRepository
  private let targetUserID: Int
  
  init(
    presenter: FollowerListPresentable,
    userManager: MutableUserManagerStream,
    followRepository: FollowRepository,
    targetUserID: Int
  ) {
    self.userManager = userManager
    self.followRepository = followRepository
    self.targetUserID = targetUserID 
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchFollowerList()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchFollowerList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let followerList = await self.followRepository.followerList(
        targetID: self.targetUserID,
        userID: self.userManager.userID
      ) {
        self.followerList.accept(followerList)
      }
    }
  }
}
