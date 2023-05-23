//
//  BrandDetailInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import Util
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

import Foundation

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
  private let brandRepository: BrandRepository

  //var brandInfoData: PublishSubject<BrandDTO> = .init()
  var brandInfoData: BehaviorRelay<BrandDTO?> = .init(value: nil)
  var brandProductUsagePostings: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: BrandDetailPresentable,
    brandInfo: BrandDTO,
    brandRepository: BrandRepository
  ) {
    self.brandInfo = brandInfo
    self.brandRepository = brandRepository
    super.init(presenter: presenter)
    presenter.listener = self
    
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()

    
//    DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
      //self.brandInfoData.onNext(self.brandInfo)
      self.brandInfoData.accept(brandInfo)
//    })

    
    Task {
      await fetchBrandPostings(
        brandID: brandInfo.id,
        userID: 326,
        createdAt: Int.max
      )
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popBrandDetailVC(with popType: PopType) {
    self.listener?.detachBrandDetailVC(with: popType)
  }
  
  func fetchBrandPostings(brandID: Int, userID: Int, createdAt: Int) async {
    Task.detached { [weak self] in
      guard let self else { return }
      if let usagePosting = await self.brandRepository.getBrandProductUsagePosting(brandID: brandID, userID: userID, createdAt: createdAt) {
        self.brandProductUsagePostings.accept(usagePosting)
      }
    }
  }
}
