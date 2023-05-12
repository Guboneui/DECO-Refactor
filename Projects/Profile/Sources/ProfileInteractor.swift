//
//  ProfileInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift

public protocol ProfileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfilePresentable: Presentable {
    var listener: ProfilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol ProfileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable, ProfilePresentableListener {

    weak var router: ProfileRouting?
    weak var listener: ProfileListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProfilePresentable) {
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
}
