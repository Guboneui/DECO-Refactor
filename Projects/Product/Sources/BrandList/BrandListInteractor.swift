//
//  BrandListInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs
import RxSwift

protocol BrandListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BrandListPresentable: Presentable {
    var listener: BrandListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BrandListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BrandListInteractor: PresentableInteractor<BrandListPresentable>, BrandListInteractable, BrandListPresentableListener {

    weak var router: BrandListRouting?
    weak var listener: BrandListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: BrandListPresentable) {
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