//
//  ProductCategoryDetailInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import Util

import RIBs
import RxSwift

protocol ProductCategoryDetailRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductCategoryDetailPresentable: Presentable {
  var listener: ProductCategoryDetailPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductCategoryDetailListener: AnyObject {
  func popProductCategoryDetailVC(with popType: PopType)
}

final class ProductCategoryDetailInteractor: PresentableInteractor<ProductCategoryDetailPresentable>, ProductCategoryDetailInteractable, ProductCategoryDetailPresentableListener {
  
  weak var router: ProductCategoryDetailRouting?
  weak var listener: ProductCategoryDetailListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: ProductCategoryDetailPresentable) {
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
  
  func popProductCategoryDetailDetailVC(with popType: PopType) {
    listener?.popProductCategoryDetailVC(with: popType)
  }
}
