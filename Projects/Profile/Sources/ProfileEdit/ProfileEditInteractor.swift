//
//  ProfileEditInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/28.
//

import User
import Util
import Entity
import Networking

import RIBs
import RxSwift

protocol ProfileEditRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileEditPresentable: Presentable {
  var listener: ProfileEditPresentableListener? { get set }
  
  func defaultUserProfileInfo(with userInfo: UserManagerModel)
}

protocol ProfileEditListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func detachProfileEditVC(with popType: PopType)
}

final class ProfileEditInteractor: PresentableInteractor<ProfileEditPresentable>, ProfileEditInteractable, ProfileEditPresentableListener {
  
  weak var router: ProfileEditRouting?
  weak var listener: ProfileEditListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let userManager: MutableUserManagerStream
  private let userProfileRepository: UserProfileRepository
  
  init(
    presenter: ProfileEditPresentable,
    userManager: MutableUserManagerStream,
    userProfileRepository: UserProfileRepository
  ) {
    self.userManager = userManager
    self.userProfileRepository = userProfileRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.setUserDefaultProfileInfo()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func setUserDefaultProfileInfo() {
    self.userManager.userInfo
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.presenter.defaultUserProfileInfo(with: $0)
      }).disposed(by: disposeBag)
  }
  
  func popProfileEditVC(with popType: PopType) {
    self.listener?.detachProfileEditVC(with: popType)
  }
  
  func fetchEditProfile(profileName: String, nickName: String, description: String) {
    let backgroundImage: String = self.userManager.userBackgroundImage
    let profileImage: String = self.userManager.userProfileImage
    
    Task.detached { [weak self] in
      guard let self else { return }
      if let editedProfileInfo = await self.userProfileRepository.editProfile(
        userID: self.userManager.userID,
        backgroundURL: backgroundImage,
        profileURL: profileImage,
        profileName: profileName,
        profileDescription: description,
        nickName: nickName
      ) {
        await self.updateUserProfile(with: editedProfileInfo)
        await self.popEditViewController()
      }
    }
  }
  
  @MainActor
  private func updateUserProfile(with profileInfo: ProfileDTO) {
    self.userManager.updateUserInfo(
      with: self.userManager.castingUserInfoModel(
        with: profileInfo
      )
    )
  }
  
  @MainActor
  private func popEditViewController() {
    self.listener?.detachProfileEditVC(with: .BackButton)
  }
}
