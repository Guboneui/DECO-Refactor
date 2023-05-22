//
//  BrandListInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import Util
import Entity
import Networking



import RIBs
import RxSwift
import RxRelay

protocol BrandListRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
  func attachBrandDetailVC(brandInfo: BrandDTO)
  func detachBrandDetailVC(with popType: PopType)
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
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let brandRepository: BrandRepository
  
  var brandList: BehaviorRelay<[BrandDTO]> = .init(value: [])
  
  
  init(
    presenter: BrandListPresentable,
    brandRepository: BrandRepository
  ) {
    self.brandRepository = brandRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    Task.detached(priority: .background) { [weak self] in
      guard let self else { return }
      await self.fetchBrandListAPI()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchBrandListAPI() async {
    let brandList = await brandRepository.getBrandList()
    if let brandList {
      self.brandList.accept(brandList)
    }
  }
  
  func pushBrandDetailVC(brandInfo: BrandDTO) {
    self.router?.attachBrandDetailVC(brandInfo: brandInfo)
  }
  
  func detachBrandDetailVC(with popType: PopType) {
    self.router?.detachBrandDetailVC(with: popType)
  }
}
