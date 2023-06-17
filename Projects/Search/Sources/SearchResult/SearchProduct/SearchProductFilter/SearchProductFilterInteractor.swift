//
//  SearchProductFilterInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/18.
//

import RIBs
import RxSwift

protocol SearchProductFilterRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchProductFilterPresentable: Presentable {
    var listener: SearchProductFilterPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchProductFilterListener: AnyObject {
  func dismissFilterModalVC()
}

final class SearchProductFilterInteractor: PresentableInteractor<SearchProductFilterPresentable>, SearchProductFilterInteractable, SearchProductFilterPresentableListener {

    weak var router: SearchProductFilterRouting?
    weak var listener: SearchProductFilterListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchProductFilterPresentable) {
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
  
  func dismissFilterModalVC() {
    listener?.dismissFilterModalVC()
  }
}
