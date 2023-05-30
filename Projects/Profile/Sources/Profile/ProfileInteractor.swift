//
//  ProfileInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import Util
import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

public protocol ProfileRouting: ViewableRouting {
  func attachAppSettingVC()
  func detachAppSettingVC(with popType: PopType)
  
  func attachProfileEditVC()
  func detachProfileEditVC(with popType: PopType)
  
  func attachFollowVC(with targetUserID: Int)
  func detachFollowVC(with popType: PopType)
}

protocol ProfilePresentable: Presentable {
  var listener: ProfilePresentableListener? { get set }
  
  func setUserProfile(with profileInfo: UserManagerModel)
}

public protocol ProfileListener: AnyObject {
  
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable, ProfilePresentableListener {
  
  weak var router: ProfileRouting?
  weak var listener: ProfileListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let userProfileRepository: UserProfileRepository
  private let userManager: MutableUserManagerStream
  var userPostings: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: ProfilePresentable,
    userProfileRepository: UserProfileRepository,
    userManager: MutableUserManagerStream
  ) {
    self.userProfileRepository = userProfileRepository
    self.userManager = userManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.setUserProfile()
    self.fetchUserPostings(
      id: userManager.userID,
      userID: userManager.userID,
      createdAt: Int.max
    )
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
 
  
  private func setUserProfile() {
    self.userManager.userInfo
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.presenter.setUserProfile(with: $0)
        
      }).disposed(by: disposeBag)
  }
  
  func fetchUserPostings(id: Int, userID: Int, createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let postings = await self.userProfileRepository.userPostings(
        id: userID,
        userID: userID,
        createdAt: createdAt
      )
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
  
  func pushProfileEditVC() {
    router?.attachProfileEditVC()
  }
  
  func detachProfileEditVC(with popType: PopType) {
    router?.detachProfileEditVC(with: popType)
  }
  
  func pushFollowVC() {
    router?.attachFollowVC(with: userManager.userID)
  }
  
  func detachFollowVC(with popType: PopType) {
    router?.detachFollowVC(with: popType)
  }
}
