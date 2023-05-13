//
//  ProductCategoryInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs
import RxSwift

protocol ProductCategoryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductCategoryPresentable: Presentable {
    var listener: ProductCategoryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductCategoryListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProductCategoryInteractor: PresentableInteractor<ProductCategoryPresentable>, ProductCategoryInteractable, ProductCategoryPresentableListener {

    weak var router: ProductCategoryRouting?
    weak var listener: ProductCategoryListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProductCategoryPresentable) {
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
