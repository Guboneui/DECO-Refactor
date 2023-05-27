//
//  ProfileEditInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/28.
//

import Util

import RIBs
import RxSwift

protocol ProfileEditRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileEditPresentable: Presentable {
    var listener: ProfileEditPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProfileEditListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func detachProfileEditVC(with popType: PopType)
}

final class ProfileEditInteractor: PresentableInteractor<ProfileEditPresentable>, ProfileEditInteractable, ProfileEditPresentableListener {
  
  

    weak var router: ProfileEditRouting?
    weak var listener: ProfileEditListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProfileEditPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
  
  func popProfileEditVC(with popType: PopType) {
    self.listener?.detachProfileEditVC(with: popType)
  }
}
