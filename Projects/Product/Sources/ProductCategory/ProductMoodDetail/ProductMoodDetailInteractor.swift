//
//  ProductMoodDetailInteractor.swift
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

protocol ProductMoodDetailRouting: ViewableRouting {
  func attachMoodModalVC()
  func detachMoodModalVC()
  
  func attachCategoryColorModalVC()
  func detachCategoryColorModalVC()
  
  func attachProductDetailVC(with productInfo: ProductDTO)
  func detachProductDetailVC(with popType: PopType)
}

protocol ProductMoodDetailPresentable: Presentable {
  var listener: ProductMoodDetailPresentableListener? { get set }
  func setCurrentMood(mood: String)
}

protocol ProductMoodDetailListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func popProductMoodDetailVC(with popType: Util.PopType)
}

final class ProductMoodDetailInteractor: PresentableInteractor<ProductMoodDetailPresentable>, ProductMoodDetailInteractable, ProductMoodDetailPresentableListener {
  
  weak var router: ProductMoodDetailRouting?
  weak var listener: ProductMoodDetailListener?
  
  var productLists: BehaviorRelay<[ProductDTO]> = .init(value: [])
  var selectedFilter: BehaviorRelay<[(name: String, id: Int, filterType: Filter, isSelected: Bool)]> = .init(value: [])
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let userManager: MutableUserManagerStream
  private let productRepository: ProductRepository
  private let bookmarkRepository: BookmarkRepository
  private let selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  private let productStreamManager: MutableProductStream
  
  init(
    presenter: ProductMoodDetailPresentable,
    productRepository: ProductRepository,
    bookmarkRepository: BookmarkRepository,
    userManager: MutableUserManagerStream,
    selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream,
    productStreamManager: MutableProductStream
  ) {
    self.userManager = userManager
    self.productRepository = productRepository
    self.bookmarkRepository = bookmarkRepository
    self.selectedFilterInProductMood = selectedFilterInProductMood
    self.productStreamManager = productStreamManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.setupBindingSelectedFilter()
    self.setupProductListStreamBinding()
  }
  
  private func setupProductListStreamBinding() {
    productStreamManager.productList
      .subscribe(onNext: { [weak self] list in
        guard let self else { return }
        self.productLists.accept(list)
      }).disposed(by: disposeBag)
  }
  
  private func setupBindingSelectedFilter() {
    self.selectedFilterInProductMood.selectedFilter
      .share()
      .observe(on: MainScheduler.instance)
      .map{$0.selectedMood}
      .compactMap{$0}
      .subscribe(onNext: { [weak self] mood in
        guard let self else { return }
        self.presenter.setCurrentMood(mood: mood.title)
      }).disposed(by: disposeBag)
    
    self.selectedFilterInProductMood.selectedFilter
      .share()
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        let categories: [(String, Int, Filter, Bool)] = filter.selectedCategories.map{($0.title, $0.id, Filter.Category, true)}
        let colors: [(String, Int, Filter, Bool)] = filter.selectedColors.map{($0.name, $0.id, Filter.Color, true)}
        
        if (categories + colors).isEmpty {
          self.selectedFilter.accept(categories + colors)
        } else {
          self.selectedFilter.accept([("초기화", -1, Filter.None, false)] + categories + colors)
        }
        
        Task.detached { [weak self] in
          guard let inSelf = self else { return }
          if let productList = await inSelf.productRepository.getProductOfCategory(
            param: ItemFilterRequest(
              userId: inSelf.userManager.userID,
              itemCategoryIds: filter.selectedCategories.map{$0.id},
              colorIds: filter.selectedColors.map{$0.id},
              styleIds: [filter.selectedMood?.id ?? 0],
              createdAt: Int.max,
              name: "")
          ) {
            inSelf.productStreamManager.updateProductList(with: productList)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func fetchProductList(createdAt: Int) {
    selectedFilterInProductMood.selectedFilter
      .take(1)
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        
        Task.detached { [weak self] in
          guard let inSelf = self else { return }
          if let productList = await inSelf.productRepository.getProductOfCategory(
            param: ItemFilterRequest(
              userId: inSelf.userManager.userID,
              itemCategoryIds: filter.selectedCategories.map{$0.id},
              colorIds: filter.selectedColors.map{$0.id},
              styleIds: [filter.selectedMood?.id ?? 0],
              createdAt: createdAt,
              name: "")
          ), !productList.isEmpty {
            let prevData = inSelf.productLists.value
            inSelf.productStreamManager.updateProductList(with: prevData + productList)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func updateFilter(categoryList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)], colorList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)]) {
    let categories: [ProductCategoryModel] = categoryList.map{ProductCategoryModel(id: $0.id, title: $0.name)}
    let colors: [ProductColorModel] = colorList.map{ProductColorModel(name: $0.name, image: Util.getColorImage(id: $0.id), id: $0.id)}
    self.selectedFilterInProductMood.updateFilterStream(categories: categories, colors: colors)
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
  
  func popProductMoodDetailVC(with popType: PopType) {
    selectedFilterInProductMood.clearStream()
    listener?.popProductMoodDetailVC(with: popType)
  }
  
  
  func showMoodModalVC() {
    router?.attachMoodModalVC()
  }
  
  func dismissMoodModalVC() {
    router?.detachMoodModalVC()
  }
  
  
  func showCategoryColorModalVC() {
    router?.attachCategoryColorModalVC()
  }
  
  func dismissCategoryColorModalVC() {
    router?.detachCategoryColorModalVC()
  }
  
  func pushProductDetailVC(at index: Int, with productInfo: ProductDTO) {
    productStreamManager.updateSelectedIndex(index: index)
    router?.attachProductDetailVC(with: productInfo)
  }
  
  func popProductDetailVC(with popType: Util.PopType) {
    router?.detachProductDetailVC(with: popType)
  }
}
