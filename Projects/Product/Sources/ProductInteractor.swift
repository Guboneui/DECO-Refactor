//
//  ProductInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift

public protocol ProductRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductPresentable: Presentable {
    var listener: ProductPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol ProductListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProductInteractor: PresentableInteractor<ProductPresentable>, ProductInteractable, ProductPresentableListener {

    weak var router: ProductRouting?
    weak var listener: ProductListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProductPresentable) {
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