//
//  ProductBookmarkInteractor.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol ProductBookmarkRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProductBookmarkPresentable: Presentable {
  var listener: ProductBookmarkPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductBookmarkListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProductBookmarkInteractor: PresentableInteractor<ProductBookmarkPresentable>, ProductBookmarkInteractable, ProductBookmarkPresentableListener {
  
  weak var router: ProductBookmarkRouting?
  weak var listener: ProductBookmarkListener?
  
  var currentSelectedCategory: Int = -1
  var productBookmarkCategory: BehaviorRelay<[(category: ProductCategoryDTO, isSelected: Bool)]> = .init(value: [])
  var productBookmarkList: BehaviorRelay<[(bookmarkData: BookmarkDTO, isBookmark: Bool)]> = .init(value: [])
  
  private let userManager: MutableUserManagerStream
  private let productRepository: ProductRepository
  private let bookmarkRepository: BookmarkRepository
  
  init(
    presenter: ProductBookmarkPresentable,
    userManager: MutableUserManagerStream,
    productRepository: ProductRepository,
    bookmarkRepository: BookmarkRepository
  ) {
    self.userManager = userManager
    self.productRepository = productRepository
    self.bookmarkRepository = bookmarkRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchProductCategoryList()
    
    self.fetchBookmarkListWithCategory(
      categoryID: self.currentSelectedCategory,
      createdAt: Int.max
    )
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchProductCategoryList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let productCategory = await self.productRepository.getProductCategoryList() {
        self.productBookmarkCategory.accept(
          [(ProductCategoryDTO(categoryName: "전체", id: -1), true)] +
          productCategory.sorted{$0.id < $1.id}.map{($0, false)}
        )
      }
    }
  }
  
  func fetchBookmarkListWithCategory (categoryID: Int, createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let bookmarkList = await self.bookmarkRepository.bookmarkList(
        userId: self.userManager.userID,
        scrapType: BookMarkSegmentType.Product.rawValue,
        itemCategoryId: categoryID,
        boardCategoryId: 0,
        createdAt: createdAt
      ), !bookmarkList.isEmpty {
        let prevBookmarkList = self.productBookmarkList.value
        let fetchedBookmarkList: [(BookmarkDTO, Bool)] = bookmarkList.map{($0, true)}
        self.productBookmarkList.accept(prevBookmarkList + fetchedBookmarkList)
      }
    }
  }
  
  func selectProductBookmarkCategory(categoryID: Int, index: Int) {
    var categoryList: [(category: ProductCategoryDTO, isSelected: Bool)] = productBookmarkCategory.value.map{($0.category, false)}
    categoryList[index].isSelected = true
    self.currentSelectedCategory = categoryID
    self.productBookmarkCategory.accept(categoryList)
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
}
