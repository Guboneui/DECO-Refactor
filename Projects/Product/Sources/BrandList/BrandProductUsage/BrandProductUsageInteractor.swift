//
//  BrandProductUsageInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/24.
//

import Util
import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol BrandProductUsageRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BrandProductUsagePresentable: Presentable {
  var listener: BrandProductUsagePresentableListener? { get set }
  
  func setNavTitleWithBrandName(with title: String)
}

protocol BrandProductUsageListener: AnyObject {
  func detachBrandProductUsageVC(with popType: PopType)
}

final class BrandProductUsageInteractor: PresentableInteractor<BrandProductUsagePresentable>, BrandProductUsageInteractable, BrandProductUsagePresentableListener {
  
  weak var router: BrandProductUsageRouting?
  weak var listener: BrandProductUsageListener?
  
  private let brandInfo: BrandDTO
  private let brandRepository: BrandRepository
  private let userManager: MutableUserManagerStream
  
  var brandProductUsagePosting: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: BrandProductUsagePresentable,
    brandInfo: BrandDTO,
    brandRepository: BrandRepository,
    userManager: MutableUserManagerStream
  ) {
    self.brandInfo = brandInfo
    self.brandRepository = brandRepository
    self.userManager = userManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.presenter.setNavTitleWithBrandName(with: brandInfo.name)
    
    Task {
      await fetchBrandPostings(createdAt: Int.max)
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func popBrandProductUsageVC(with popType: PopType) {
    listener?.detachBrandProductUsageVC(with: popType)
  }
  
  func fetchBrandPostings(createdAt: Int) async {
    Task.detached { [weak self] in
      guard let self else { return }
      if let usagePosting = await self.brandRepository.getBrandProductUsagePosting(
        brandID: self.brandInfo.id,
        userID: 326,
        createdAt: createdAt
      ) {
        let prevData = self.brandProductUsagePosting.value
        if !usagePosting.isEmpty {
          self.brandProductUsagePosting.accept(prevData + usagePosting)
        }
      }
    }
  }
}
