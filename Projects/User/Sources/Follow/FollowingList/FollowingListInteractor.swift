//
//  FollowingListInteractor.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Networking

import Entity

import RIBs
import RxSwift
import RxRelay

protocol FollowingListRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FollowingListPresentable: Presentable {
  var listener: FollowingListPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FollowingListListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FollowingListInteractor: PresentableInteractor<FollowingListPresentable>, FollowingListInteractable, FollowingListPresentableListener {
  
  
  
  weak var router: FollowingListRouting?
  weak var listener: FollowingListListener?
  
  var followingList: BehaviorRelay<[UserDTO]> = .init(value: [])
  lazy var userID: Int = userManager.userID
  
  private let userManager: MutableUserManagerStream
  private let followRepository: FollowRepository
  private let userProfileRepository: UserProfileRepository
  private let targetUserID: Int
  
  init(
    presenter: FollowingListPresentable,
    userManager: MutableUserManagerStream,
    followRepository: FollowRepository,
    userProfileRepository: UserProfileRepository,
    targetUserID: Int
  ) {
    self.userManager = userManager
    self.followRepository = followRepository
    self.userProfileRepository = userProfileRepository
    self.targetUserID = targetUserID
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchFollowingList()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchFollowingList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let followingList = await self.followRepository.followingList(
        targetID: self.targetUserID,
        userID: self.userManager.userID, name: ""
      ) {
        self.followingList.accept(followingList)
      }
    }
  }
  
  func follow(targetUserID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.followRepository.follow(targetID: targetUserID, userID: self.userID, follow: true)
      
      if let userInfo = await self.userProfileRepository.userProfile(id: self.userID, userID: self.userID) {
        self.userManager.updateUserInfo(with: self.userManager.castingUserInfoModel(with: userInfo))
      }
    }
  }
  
  func unfollow(targetUserID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.followRepository.unfollow(targetID: targetUserID, userID: self.userID, follow: false)
      
      if let userInfo = await self.userProfileRepository.userProfile(id: self.userID, userID: self.userID) {
        self.userManager.updateUserInfo(with: self.userManager.castingUserInfoModel(with: userInfo))
      }
    }
  }
  
  func changeFollowersState(with userInfo: UserDTO, index: Int) {
    let shouldInputData: UserDTO = UserDTO(
      profileUrl: userInfo.profileUrl,
      followStatus: !userInfo.followStatus,
      nickName: userInfo.nickName,
      userId: userInfo.userId,
      profileName: userInfo.profileName
    )
    
    var shouldChangedData = followingList.value
    shouldChangedData[index] = shouldInputData
    followingList.accept(shouldChangedData)
  }
}
