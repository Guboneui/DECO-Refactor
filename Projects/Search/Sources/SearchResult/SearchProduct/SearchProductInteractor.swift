//
//  SearchProductInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import User
import Entity
import Networking
import ProductDetail
import RIBs
import RxSwift
import RxRelay

protocol SearchProductRouting: ViewableRouting {
  func attachFilterModalVC()
  func detachFilterModalVC()
}

protocol SearchProductPresentable: Presentable {
  var listener: SearchProductPresentableListener? { get set }
  @MainActor func showEmptyNotice()
}

protocol SearchProductListener: AnyObject {
  func pushProductDetailVC(with productInfo: ProductDTO)
}

final class SearchProductInteractor: PresentableInteractor<SearchProductPresentable>, SearchProductInteractable, SearchProductPresentableListener {
  
  weak var router: SearchProductRouting?
  weak var listener: SearchProductListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let searchText: String
  private let searchRepository: SearchRepository
  private let bookmarkRepository: BookmarkRepository
  private let userManager: MutableUserManagerStream
  private let productStreamManager: MutableProductStream
  
  var productList: BehaviorRelay<[ProductDTO]> = .init(value: [])
  
  init(
    presenter: SearchProductPresentable,
    searchText: String,
    searchRepository: SearchRepository,
    bookmarkRepository: BookmarkRepository,
    userManager: MutableUserManagerStream,
    productStreamManager: MutableProductStream
  ) {
    self.searchText = searchText
    self.searchRepository = searchRepository
    self.bookmarkRepository = bookmarkRepository
    self.userManager = userManager
    self.productStreamManager = productStreamManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchProductList(createdAt: Int.max)
    self.setupProductListStreamBinding()
    
    var arr: [Int] = []
    print(arr.isEmpty)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func setupProductListStreamBinding() {
    productStreamManager.productList
      .subscribe(onNext: { [weak self] list in
        guard let self else { return }
        self.productList.accept(list)
      }).disposed(by: disposeBag)
  }
  
  func fetchProductList(createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let productList = await self.searchRepository.getSearchProductList(
        param: ItemFilterRequest(
          userId: self.userManager.userID,
          itemCategoryIds: [],
          colorIds: [],
          styleIds: [],
          createdAt: createdAt,
          name: self.searchText
        )
      ) {
        let prevData = self.productList.value
        if !productList.isEmpty {
          self.productStreamManager.updateProductList(with: prevData + productList)
        }
        
        if prevData.isEmpty && productList.isEmpty {
          await self.presenter.showEmptyNotice()
        }
      }
    }
  }
  
  func fetchAddBookmark(with productID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.bookmarkRepository.addBookmark(
        productId: productID,
        boardId: 0,
        userId: self.userManager.userID
      )
    }
  }
  
  func fetchDeleteBookmark(with productID: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      _ = await self.bookmarkRepository.deleteBookmark(
        productId: productID,
        boardId: 0,
        userId: self.userManager.userID
      )
    }
  }
  
  func updateBookmarkState(at index: Int, product: ProductDTO) {
    productStreamManager.updateProduct(at: index, product: product)
  }
  
  func pushProductDetailVC(at index: Int, with productInfo: ProductDTO) {
    productStreamManager.updateSelectedIndex(index: index)
    listener?.pushProductDetailVC(with: productInfo)
  }
  
  func showFilterModalVC() {
    router?.attachFilterModalVC()
  }
  
  func dismissFilterModalVC() {
    router?.detachFilterModalVC()
  }
}

