//
//  ProfileEditInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/28.
//

import User
import Util

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
  
  init(
    presenter: ProfileEditPresentable,
    userManager: MutableUserManagerStream
  ) {
    self.userManager = userManager
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
}
