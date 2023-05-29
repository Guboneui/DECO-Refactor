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
  var productBookMarkCategory: BehaviorRelay<[(category: ProductCategoryDTO, isSelected: Bool)]> = .init(value: [])
  var productBookmarkList: BehaviorRelay<[BookmarkDTO]> = .init(value: [])
  
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
    
    
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchProductCategoryList() {
    Task.detached { [weak self] in
      guard let self else { return }
      if let productCategory = await self.productRepository.getProductCategoryList() {
        self.productBookMarkCategory.accept(
          [(ProductCategoryDTO(categoryName: "전체", id: -1), true)] +
          productCategory.sorted{$0.id < $1.id}.map{($0, false)}
        )
      }
    }
  }
  
  func fetchBookmarkListWithCategory(categoryID: Int, createdAt: Int) {
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
        self.productBookmarkList.accept(prevBookmarkList + bookmarkList)
      }
    }
  }
  
  func selectProductBookmarkCategory(categoryID: Int, index: Int) {
    var categoryList: [(category: ProductCategoryDTO, isSelected: Bool)] = productBookMarkCategory.value.map{($0.category, false)}
    categoryList[index].isSelected = true
    self.currentSelectedCategory = categoryID
    self.productBookMarkCategory.accept(categoryList)
  }
}
