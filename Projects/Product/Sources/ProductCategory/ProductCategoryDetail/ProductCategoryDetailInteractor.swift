//
//  ProductCategoryDetailInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import User
import Util
import Entity
import Networking
import ProductDetail

import RIBs
import RxSwift
import RxRelay

protocol ProductCategoryDetailRouting: ViewableRouting {
  func attachCategoryModalVC()
  func detachCategoryModalVC()
  
  func attachMoodColorModalVC()
  func detachMoodColorModalVC()
  
  func attachProductDetailVC(with productInfo: ProductDTO)
  func detachProductDetailVC(with popType: PopType)
}

protocol ProductCategoryDetailPresentable: Presentable {
  var listener: ProductCategoryDetailPresentableListener? { get set }
  func setCurrentCategory(category: String)
}

protocol ProductCategoryDetailListener: AnyObject {
  func popProductCategoryDetailVC(with popType: PopType)
}

final class ProductCategoryDetailInteractor: PresentableInteractor<ProductCategoryDetailPresentable>, ProductCategoryDetailInteractable, ProductCategoryDetailPresentableListener {
  
  weak var router: ProductCategoryDetailRouting?
  weak var listener: ProductCategoryDetailListener?
  
  var productLists: BehaviorRelay<[ProductDTO]> = .init(value: [])
  var selectedFilter: BehaviorRelay<[(name: String, id: Int, filterType: Filter, isSelected: Bool)]> = .init(value: [])
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let userManager: MutableUserManagerStream
  private let productRepository: ProductRepository
  private let bookmarkRepository: BookmarkRepository
  private let selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  private let productStreamManager: MutableProductStream
  
  init(
    presenter: ProductCategoryDetailPresentable,
    productRepository: ProductRepository,
    bookmarkRepository: BookmarkRepository,
    userManager: MutableUserManagerStream,
    selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream,
    productStreamManager: MutableProductStream
  ) {
    self.userManager = userManager
    self.productRepository = productRepository
    self.bookmarkRepository = bookmarkRepository
    self.selectedFilterInProductCategory = selectedFilterInProductCategory
    self.productStreamManager = productStreamManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    setupBindingSelectedFilter()
    setupProductListStreamBinding()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func setupProductListStreamBinding() {
    productStreamManager.productList
      .subscribe(onNext: { [weak self] list in
        guard let self else { return }
        self.productLists.accept(list)
      }).disposed(by: disposeBag)
  }
  
  private func setupBindingSelectedFilter() {
    self.selectedFilterInProductCategory.selectedFilter
      .share()
      .observe(on: MainScheduler.instance)
      .map{$0.selectedCategory}
      .compactMap{$0}
      .subscribe(onNext: { [weak self] category in
        guard let self else { return }
        self.presenter.setCurrentCategory(category: category.title)
      }).disposed(by: disposeBag)
    
    self.selectedFilterInProductCategory.selectedFilter
      .share()
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        
        let moods: [(String, Int, Filter, Bool)] = filter.selectedMoods.map{($0.title, $0.id, Filter.Mood, true)}
        let colors: [(String, Int, Filter, Bool)] = filter.selectedColors.map{($0.name, $0.id, Filter.Color, true)}
        
        if (moods + colors).isEmpty {
          self.selectedFilter.accept(moods + colors)
        } else {
          self.selectedFilter.accept([("초기화", -1, Filter.None, false)] + moods + colors)
        }
        
        Task.detached { [weak self] in
          guard let inSelf = self else { return }
          if let productList = await inSelf.productRepository.getProductOfCategory(
            param: ItemFilterRequest(
              userId: inSelf.userManager.userID,
              itemCategoryIds: [filter.selectedCategory?.id ?? 0],
              colorIds: filter.selectedColors.map{$0.id},
              styleIds: filter.selectedMoods.map{$0.id},
              createdAt: Int.max,
              name: "")
          ) {
            inSelf.productStreamManager.updateProductList(with: productList)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func fetchProductList(createdAt: Int) {
    selectedFilterInProductCategory.selectedFilter
      .take(1)
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        
        Task.detached { [weak self] in
          guard let inSelf = self else { return }
          if let productList = await inSelf.productRepository.getProductOfCategory(
            param: ItemFilterRequest(
              userId: inSelf.userManager.userID,
              itemCategoryIds: [filter.selectedCategory?.id ?? 0],
              colorIds: filter.selectedColors.map{$0.id},
              styleIds: filter.selectedMoods.map{$0.id},
              createdAt: createdAt,
              name: "")
          ), !productList.isEmpty {
            let prevData = inSelf.productLists.value
            inSelf.productStreamManager.updateProductList(with: prevData + productList)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func updateFilter(moodList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)], colorList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)]) {
    let moods: [ProductCategoryModel] = moodList.map{ProductCategoryModel(id: $0.id, title: $0.name)}
    let colors: [ProductColorModel] = colorList.map{ProductColorModel(name: $0.name, image: Util.getColorImage(id: $0.id), id: $0.id)}
    self.selectedFilterInProductCategory.updateFilterStream(moods: moods, colors: colors)
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
  
  func popProductCategoryDetailDetailVC(with popType: PopType) {
    selectedFilterInProductCategory.clearStream()
    listener?.popProductCategoryDetailVC(with: popType)
  }
  
  func showCategoryModalVC() {
    router?.attachCategoryModalVC()
  }
  
  func dismissCategoryModalVC() {
    router?.detachCategoryModalVC()
  }
  
  func showMoodColorModalVC() {
    router?.attachMoodColorModalVC()
  }
  
  func dismissMoodColorModalVC() {
    router?.detachMoodColorModalVC()
  }
  
  func pushProductDetailVC(at index: Int, with productInfo: ProductDTO) {
    productStreamManager.updateSelectedIndex(index: index)
    router?.attachProductDetailVC(with: productInfo)
  }
  
  func popProductDetailVC(with popType: PopType) {
    router?.detachProductDetailVC(with: popType)
  }
}
