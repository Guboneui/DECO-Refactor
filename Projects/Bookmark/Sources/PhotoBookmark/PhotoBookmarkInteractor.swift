//
//  PhotoBookmarkInteractor.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs
import RxSwift

protocol PhotoBookmarkRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PhotoBookmarkPresentable: Presentable {
    var listener: PhotoBookmarkPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PhotoBookmarkListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PhotoBookmarkInteractor: PresentableInteractor<PhotoBookmarkPresentable>, PhotoBookmarkInteractable, PhotoBookmarkPresentableListener {

    weak var router: PhotoBookmarkRouting?
    weak var listener: PhotoBookmarkListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: PhotoBookmarkPresentable) {
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
