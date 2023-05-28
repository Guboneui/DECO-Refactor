//
//  ProductBookmarkInteractor.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs
import RxSwift

protocol ProductBookmarkRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductBookmarkPresentable: Presentable {
    var listener: ProductBookmarkPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductBookmarkListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProductBookmarkInteractor: PresentableInteractor<ProductBookmarkPresentable>, ProductBookmarkInteractable, ProductBookmarkPresentableListener {

    weak var router: ProductBookmarkRouting?
    weak var listener: ProductBookmarkListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProductBookmarkPresentable) {
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
