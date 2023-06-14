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
  private let bookmarkRepository: BookmarkRepository
  private let productStreamManager: MutableProductStream
  
  
  private var productDetailInfo: ProductDetailDTO?
  
  init(
    presenter: ProductDetailPresentable,
    productInfo: ProductDTO,
    userManager: MutableUserManagerStream,
    productRepository: ProductRepository,
    bookmarkRepository: BookmarkRepository,
    productStreamManager: MutableProductStream
  ) {
    self.productInfo = productInfo
    self.userManager = userManager
    self.productRepository = productRepository
    self.bookmarkRepository = bookmarkRepository
    self.productStreamManager = productStreamManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.fetchProductInfo(
        productID: self.productInfo.id,
        userID: self.userManager.userID
      )
    }
    
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
        print("구매 링크 없음 토스트 띄우기")
      }
    }
  }
  
  func fetchBookmark() {
    if let productDetailInfo {
      let product = productDetailInfo.product
      
      Task.detached { [weak self] in
        guard let self else { return }
        
        if productDetailInfo.scrap {
          _ = await self.bookmarkRepository.deleteBookmark(
            productId: product.id,
            boardId: 0,
            userId: self.userManager.userID
          )
        } else {
          _ = await self.bookmarkRepository.addBookmark(
            productId: product.id,
            boardId: 0,
            userId: self.userManager.userID
          )
        }
        
        if let product = await self.fetchProductInfo(
          productID: product.id,
          userID: self.userManager.userID
        ) {
          self.productStreamManager.updateProduct(product: product)
        }
      }
    }
  }
  
  private func fetchProductInfo(productID: Int, userID: Int) async -> ProductDTO? {
    if let productInfo = await self.productRepository.getProductInfo(
      productID: productID,
      userID: userID
    ) {
      self.productDetailInfo = productInfo
      await self.presenter.setProductInfo(with: productInfo)
      let product = productInfo.product
      return ProductDTO(
        name: product.name,
        imageUrl: product.imageUrl,
        brandName: productInfo.brandName,
        id: product.id,
        scrap: productInfo.scrap,
        createdAt: product.createdAt
      )
    } else {
      return nil
    }
  }
}
