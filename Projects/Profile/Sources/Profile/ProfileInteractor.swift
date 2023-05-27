//
//  ProfileInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import Util
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

public protocol ProfileRouting: ViewableRouting {
  func attachAppSettingVC()
  func detachAppSettingVC(with popType: PopType)
}

protocol ProfilePresentable: Presentable {
  var listener: ProfilePresentableListener? { get set }
  
  @MainActor func setUserProfile(with profileInfo: ProfileDTO)
}

public protocol ProfileListener: AnyObject {
  
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable, ProfilePresentableListener {
  
  weak var router: ProfileRouting?
  weak var listener: ProfileListener?
  
  private let userProfileRepository: UserProfileRepository
  var userPostings: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: ProfilePresentable,
    userProfileRepository: UserProfileRepository
  ) {
    self.userProfileRepository = userProfileRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchUserPostings(id: 72, userID: 72, createdAt: Int.max)
    self.fetchUserProfile(id: 72, userID: 72)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchUserProfile(id: Int, userID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let profile = await self.userProfileRepository.userProfile(id: id, userID: userID) {
        await self.presenter.setUserProfile(with: profile)
      }
    }
  }
  
  func fetchUserPostings(id: Int, userID: Int, createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let postings = await self.userProfileRepository.userPostings(id: id, userID: userID, createdAt: createdAt)
      let prevData = self.userPostings.value
      if let postings, !postings.isEmpty {
        self.userPostings.accept(prevData + postings)
      }
    }
  }
  
  func pushAppSettingVC() {
    router?.attachAppSettingVC()
  }
  
  func detachAppSettingVC(with popType: PopType) {
    router?.detachAppSettingVC(with: popType)
  }
}
