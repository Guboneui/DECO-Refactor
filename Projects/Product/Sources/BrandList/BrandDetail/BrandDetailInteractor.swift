//
//  BrandDetailInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import User
import Util
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

import Foundation

protocol BrandDetailRouting: ViewableRouting {
  func attachBrandProductUsage(brandInfo: BrandDTO)
  func detachBrandProductUsageVC(with popType: Util.PopType)
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
  private let userManager: MutableUserManagerStream
  private let brandRepository: BrandRepository
  private let productRepository: ProductRepository

  var brandInfoData: BehaviorRelay<BrandDTO?> = .init(value: nil)
  var brandProductUsagePostings: BehaviorRelay<[PostingDTO]> = .init(value: [])
  var productCategory: BehaviorRelay<[(category: ProductCategoryDTO, isSelected: Bool)]> = .init(value: [])
  
  init(
    presenter: BrandDetailPresentable,
    brandInfo: BrandDTO,
    userManager: MutableUserManagerStream,
    brandRepository: BrandRepository,
    productRepository: ProductRepository
  ) {
    self.brandInfo = brandInfo
    self.userManager = userManager
    self.brandRepository = brandRepository
    self.productRepository = productRepository
    super.init(presenter: presenter)
    presenter.listener = self
    
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()

    self.brandInfoData.accept(brandInfo)
    self.fetchBrandPostings(createdAt: Int.max)
    
    Task {
      await fetchProductCategory()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popBrandDetailVC(with popType: PopType) {
    self.listener?.detachBrandDetailVC(with: popType)
  }
  
  func fetchBrandPostings(createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let usagePostings = await self.brandRepository.getBrandProductUsagePosting(
        brandID: self.brandInfo.id,
        userID: self.userManager.userID,
        createdAt: createdAt
      ), !usagePostings.isEmpty {
        let prevData = self.brandProductUsagePostings.value
        self.brandProductUsagePostings.accept(prevData + usagePostings)
      }
    }
  }
  
  
  private func fetchProductCategory() async {
    Task.detached { [weak self] in
      guard let self else { return }
      if let productCategory = await self.productRepository.getProductCategoryList() {
        self.productCategory.accept([ProductCategoryDTO(categoryName: "전체", id: 0)] + productCategory)
      }
    }
  }
  
  func pushBrandProductUsageVC() {
    router?.attachBrandProductUsage(brandInfo: brandInfo)
  }
  
  
  func detachBrandProductUsageVC(with popType: Util.PopType) {
    router?.detachBrandProductUsageVC(with: popType)
  }
}
