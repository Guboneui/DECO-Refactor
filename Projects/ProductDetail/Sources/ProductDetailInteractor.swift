//
//  ProductDetailInteractor.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import User
import Util
import Entity
import Networking

import RIBs
import RxSwift

public protocol ProductDetailRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductDetailPresentable: Presentable {
  var listener: ProductDetailPresentableListener? { get set }
  @MainActor func setProductInfo(with productInfo: ProductDetailDTO)
}

public protocol ProductDetailListener: AnyObject {
  func popProductDetailVC(with popType: PopType)
}

final class ProductDetailInteractor: PresentableInteractor<ProductDetailPresentable>, ProductDetailInteractable, ProductDetailPresentableListener {
  
  weak var router: ProductDetailRouting?
  weak var listener: ProductDetailListener?
  
  private let productInfo: ProductDTO
  private let userManager: MutableUserManagerStream
  private let productRepository: ProductRepository
  
  private var productDetailInfo: ProductDetailDTO?
  
  init(
    presenter: ProductDetailPresentable,
    productInfo: ProductDTO,
    userManager: MutableUserManagerStream,
    productRepository: ProductRepository
  ) {
    self.productInfo = productInfo
    self.userManager = userManager
    self.productRepository = productRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchProductInfo(
      productID: productInfo.id,
      userID: userManager.userID
    )
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popProductDetailVC(with popType: PopType) {
    listener?.popProductDetailVC(with: popType)
  }
  
  func loadToSafariLink() {
    if let productDetailInfo {
      if let link = productDetailInfo.product.sellLink {
        SafariLoder.loadSafari(with: link)
      } else {
        // TODO:
        print("구매 링크 없음")
      }
    }
  }
  
  private func fetchProductInfo(productID: Int, userID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let productInfo = await self.productRepository.getProductInfo(
        productID: productID,
        userID: userID
      ) {
        self.productDetailInfo = productInfo
        await self.presenter.setProductInfo(with: productInfo)
      }
    }
  }
}
