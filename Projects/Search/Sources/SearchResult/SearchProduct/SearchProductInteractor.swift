//
//  SearchProductInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs
import RxSwift

protocol SearchProductRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchProductPresentable: Presentable {
    var listener: SearchProductPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchProductListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchProductInteractor: PresentableInteractor<SearchProductPresentable>, SearchProductInteractable, SearchProductPresentableListener {

    weak var router: SearchProductRouting?
    weak var listener: SearchProductListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchProductPresentable) {
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
