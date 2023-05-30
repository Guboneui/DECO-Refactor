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
  
  func showNoticeLabel(isEmptyArray: Bool)
}

protocol FollowerListListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FollowerListInteractor: PresentableInteractor<FollowerListPresentable>, FollowerListInteractable, FollowerListPresentableListener {
  
  weak var router: FollowerListRouting?
  weak var listener: FollowerListListener?
  
  var followerList: BehaviorRelay<[UserDTO]> = .init(value: [])
  var copiedFollowerList:[UserDTO] = []
  lazy var userID: Int = userManager.userID
  
  private let userManager: MutableUserManagerStream
  private let followRepository: FollowRepository
  private let userProfileRepository: UserProfileRepository
  private let targetUserID: Int
  
  init(
    presenter: FollowerListPresentable,
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
        self.copiedFollowerList = followerList
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
    
    var shouldChangedData = self.followerList.value
    shouldChangedData[index] = shouldInputData
    followerList.accept(shouldChangedData)
  }
  
  func showOriginFollowerList() {
    self.followerList.accept(copiedFollowerList)
    self.presenter.showNoticeLabel(isEmptyArray: false)
  }
  
  func showFilteredFollowerList(with nickname: String) {
    let filteredList = self.copiedFollowerList.filter{$0.nickName.contains(nickname)}
    self.followerList.accept(filteredList)
    self.presenter.showNoticeLabel(isEmptyArray: filteredList.isEmpty)
  }
}
