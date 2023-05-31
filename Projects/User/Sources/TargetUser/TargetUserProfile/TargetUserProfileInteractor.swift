//
//  TargetUserProfileInteractor.swift
//  User
//
//  Created by 구본의 on 2023/05/31.
//

import Util
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol TargetUserProfileRouting: ViewableRouting {
  func attachFollowVC(targetUserID: Int, targetUserNickname: String, firstFollowTabStatus: FollowTabType)
  func detachFollowVC(with popType: PopType)
}

protocol TargetUserProfilePresentable: Presentable {
  var listener: TargetUserProfilePresentableListener? { get set }
  func setUserProfileInfo(with profileInfo: ProfileDTO)
  func setTargetUserProfileInfo(with profileInfo: ProfileDTO)
  @MainActor func showEditProfileAlert()
  @MainActor func showBlockAlert()
  @MainActor func showUnblockAlert()
}

protocol TargetUserProfileListener: AnyObject {
  func popTargetUserProfileVC(with popType: PopType)
}

final class TargetUserProfileInteractor: PresentableInteractor<TargetUserProfilePresentable>, TargetUserProfileInteractable, TargetUserProfilePresentableListener {
  
  
  
  weak var router: TargetUserProfileRouting?
  weak var listener: TargetUserProfileListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  var targetUserProfileInfo: BehaviorRelay<ProfileDTO?> = .init(value: nil)
  var targetUserPostings: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  private let targetUserInfo: UserDTO
  private let userManager: MutableUserManagerStream
  private let userProfileRepository: UserProfileRepository
  private let followRepository: FollowRepository
  
  init(
    presenter: TargetUserProfilePresentable,
    targetUserInfo: UserDTO,
    userManager: MutableUserManagerStream,
    userProfileRepository: UserProfileRepository,
    followRepository: FollowRepository
  ) {
    self.targetUserInfo = targetUserInfo
    self.userManager = userManager
    self.userProfileRepository = userProfileRepository
    self.followRepository = followRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchTargetUserProfileInfo()
    self.setupBindingTargetUserProfile()
    self.fetchTargetUserPostings(createdAt: Int.max)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popTargetUserProfileVC(with popType: PopType) {
    listener?.popTargetUserProfileVC(with: popType)
  }
  
  private func fetchTargetUserProfileInfo() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let profileInfo = await self.userProfileRepository.userProfile(
        id: self.targetUserInfo.userId,
        userID: self.userManager.userID
      ) {
        self.targetUserProfileInfo.accept(profileInfo)
      }
    }
  }
  
  private func setupBindingTargetUserProfile() {
    targetUserProfileInfo
      .observe(on: MainScheduler.instance)
      .compactMap{$0}
      .bind { [weak self] targetUserInfo in
        guard let self else { return }
        if targetUserInfo.userId == self.userManager.userID {
          self.presenter.setUserProfileInfo(with: targetUserInfo)
        } else {
          self.presenter.setTargetUserProfileInfo(with: targetUserInfo)
        }

      }.disposed(by: disposeBag)
  }
  
  func fetchTargetUserPostings(createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let postings = await self.userProfileRepository.userPostings(
        id: self.targetUserInfo.userId,
        userID: self.userManager.userID,
        createdAt: createdAt
      )
      let prevData = self.targetUserPostings.value
      if let postings, !postings.isEmpty {
        self.targetUserPostings.accept(prevData + postings)
      }
    }
  }
  
  @MainActor func showAlertCurrentUserStatus() {
    if targetUserInfo.userId == userManager.userID {
      presenter.showEditProfileAlert()
    } else {
      Task.detached { [weak self] in
        guard let self else { return }
        if let status = await self.userProfileRepository.checkUserBlockStatus(
          userID: self.userManager.userID,
          targetUserID: self.targetUserInfo.userId
        ) {
          if status { await self.presenter.showUnblockAlert() }
          else { await self.presenter.showBlockAlert() }
        }
      }
    }
  }
  
  func didTapFollowButton() {
    if targetUserInfo.userId == userManager.userID {
      print("프로필 수정")
    } else {
      self.fetchTargetUserFollowUnfollow()
    }
  }
  
  private func fetchTargetUserFollowUnfollow() {
    if let targetUserProfileInfo = targetUserProfileInfo.value {
      if targetUserProfileInfo.followStatus {
        Task.detached { [weak self] in
          guard let self else { return }
          _ = await self.followRepository.unfollow(
            targetID: self.targetUserInfo.userId,
            userID: self.userManager.userID,
            follow: false
          )
        
          self.fetchTargetUserProfileInfo()
          if let userInfo = await self.userProfileRepository.userProfile(
            id: self.userManager.userID,
            userID: self.userManager.userID
          ) {
            self.userManager.updateUserInfo(with: self.userManager.castingUserInfoModel(with: userInfo))
          }
        }
      } else {
        Task.detached { [weak self] in
          guard let self else { return }
          _ = await self.followRepository.follow (
            targetID: self.targetUserInfo.userId,
            userID: self.userManager.userID,
            follow: true
          )
          self.fetchTargetUserProfileInfo()
          if let userInfo = await self.userProfileRepository.userProfile(
            id: self.userManager.userID,
            userID: self.userManager.userID
          ) {
            self.userManager.updateUserInfo(with: self.userManager.castingUserInfoModel(with: userInfo))
          }
        }
      }
    }
  }
  
  func pushFollowVC(with selectedFollowType: FollowTabType) {
    router?.attachFollowVC(
      targetUserID: targetUserInfo.userId,
      targetUserNickname: targetUserInfo.nickName,
      firstFollowTabStatus: selectedFollowType
    )
  }
  
  func detachFollowVC(with popType: Util.PopType) {
    router?.detachFollowVC(with: popType)
  }
}
