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
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchProductPresentable: Presentable {
  var listener: SearchProductPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
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
  private let userManager: MutableUserManagerStream
  private let productStreamManager: MutableProductStream
  
  var productList: BehaviorRelay<[ProductDTO]> = .init(value: [])
  
  init(
    presenter: SearchProductPresentable,
    searchText: String,
    searchRepository: SearchRepository,
    userManager: MutableUserManagerStream,
    productStreamManager: MutableProductStream
  ) {
    self.searchText = searchText
    self.searchRepository = searchRepository
    self.userManager = userManager
    self.productStreamManager = productStreamManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchProductList(createdAt: Int.max)
    self.setupProductListStreamBinding()
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
      ), !productList.isEmpty {
        let prevData = self.productList.value
        self.productStreamManager.updateProductList(with: prevData + productList)
      }
    }
  }
  
  func pushProductDetailVC(at index: Int, with productInfo: ProductDTO) {
    productStreamManager.updateSelectedIndex(index: index)
    listener?.pushProductDetailVC(with: productInfo)
  }
}

