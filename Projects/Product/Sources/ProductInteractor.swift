//
//  ProductInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift
import Networking

public enum Filter {
  case Category
  case Mood
  case Color
  case None
}

public protocol ProductRouting: ViewableRouting {
  func attachChildVCRib(with type: ProductTabType)
  func attachSearchVC()
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
  
  private let productRepository: ProductRepository
  
  init(
    presenter: ProductPresentable,
    productRepository: ProductRepository
  ) {
    self.productRepository = productRepository
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
  
  func addChildVCLayout(with type: ProductTabType) {
    router?.attachChildVCRib(with: type)
  }
  
  func pushSearchVC() {
    self.router?.attachSearchVC()
  }
}
