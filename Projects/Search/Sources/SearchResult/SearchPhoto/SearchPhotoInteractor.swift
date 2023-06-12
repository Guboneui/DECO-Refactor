//
//  SearchPhotoInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs
import RxSwift

protocol SearchPhotoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchPhotoPresentable: Presentable {
    var listener: SearchPhotoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchPhotoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchPhotoInteractor: PresentableInteractor<SearchPhotoPresentable>, SearchPhotoInteractable, SearchPhotoPresentableListener {

    weak var router: SearchPhotoRouting?
    weak var listener: SearchPhotoListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchPhotoPresentable) {
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
