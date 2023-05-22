//
//  BrandDetailInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import Util
import Entity

import RIBs
import RxSwift

protocol BrandDetailRouting: ViewableRouting {
  
}

protocol BrandDetailPresentable: Presentable {
  var listener: BrandDetailPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BrandDetailListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  
  func detachBrandDetailVC(with popType: PopType)
}

final class BrandDetailInteractor: PresentableInteractor<BrandDetailPresentable>, BrandDetailInteractable, BrandDetailPresentableListener {
  
  weak var router: BrandDetailRouting?
  weak var listener: BrandDetailListener?
  
  private let brandInfo: BrandDTO
  
  init(
    presenter: BrandDetailPresentable,
    brandInfo: BrandDTO
  ) {
    self.brandInfo = brandInfo
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    print("🔊[DEBUG]: DetailVC: \(self.brandInfo)")
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popBrandDetailVC(with popType: PopType) {
    self.listener?.detachBrandDetailVC(with: popType)
  }
}
