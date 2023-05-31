//
//  ProductMoodDetailInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import Util

import RIBs
import RxSwift

protocol ProductMoodDetailRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductMoodDetailPresentable: Presentable {
  var listener: ProductMoodDetailPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductMoodDetailListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func popProductMoodDetailVC(with popType: Util.PopType)
}

final class ProductMoodDetailInteractor: PresentableInteractor<ProductMoodDetailPresentable>, ProductMoodDetailInteractable, ProductMoodDetailPresentableListener {
  
  weak var router: ProductMoodDetailRouting?
  weak var listener: ProductMoodDetailListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: ProductMoodDetailPresentable) {
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
  
  func popProductMoodDetailVC(with popType: PopType) {
    listener?.popProductMoodDetailVC(with: popType)
  }
}
