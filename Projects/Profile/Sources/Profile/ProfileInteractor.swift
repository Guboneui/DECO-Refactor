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
  
  func attachFollowVC(targetUserID: Int, targetUserNickname: String, firstFollowTabStatus: FollowTabType)
  func detachFollowVC(with popType: PopType)
}

protocol ProfilePresentable: Presentable {
  var listener: ProfilePresentableListener? { get set }
  
  func setUserProfile(with profileInfo: ProfileDTO)
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
      .subscribe(onNext: { [weak self] userModel in
        guard let self else { return }
        self.presenter.setUserProfile(with: self.userManager.castingProfileDTOModel(with: userModel))
      }).disposed(by: disposeBag)
  }
  
  func fetchUserPostings(createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let postings = await self.userProfileRepository.userPostings(
        id: self.userManager.userID,
        userID: self.userManager.userID,
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
  
  func pushFollowVC(with selectedFollowType: FollowTabType) {
    router?.attachFollowVC(
      targetUserID: userManager.userID,
      targetUserNickname: userManager.userNickname,
      firstFollowTabStatus: selectedFollowType
    )
  }
  
  func detachFollowVC(with popType: PopType) {
    router?.detachFollowVC(with: popType)
  }
}
