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


import RIBs
import RxSwift
import RxRelay

protocol ProductMoodDetailRouting: ViewableRouting {
  func attachMoodModalVC()
  func detachMoodModalVC()
  
  func attachCategoryColorModalVC()
  func detachCategoryColorModalVC()
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
  private let selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  
  init(
    presenter: ProductMoodDetailPresentable,
    productRepository: ProductRepository,
    userManager: MutableUserManagerStream,
    selectedFilterInProductMood: MutableSelectedFilterInProductMoodStream
  ) {
    self.userManager = userManager
    self.productRepository = productRepository
    self.selectedFilterInProductMood = selectedFilterInProductMood
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.selectedFilterInProductMood.selectedFilter
      .observe(on: MainScheduler.instance)
      .map{$0.selectedMood}
      .compactMap{$0}
      .subscribe(onNext: { [weak self] mood in
        guard let self else { return }
        self.presenter.setCurrentMood(mood: mood.title)
      }).disposed(by: disposeBag)
    
    self.selectedFilterInProductMood.selectedFilter
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
            inSelf.productLists.accept(productList)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popProductMoodDetailVC(with popType: PopType) {
    listener?.popProductMoodDetailVC(with: popType)
  }
  
  func showMoodModalVC() {
    router?.attachMoodModalVC()
  }
  
  func dismissMoodModalVC() {
    router?.detachMoodModalVC()
  }
  
  func updateFilter(categoryList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)], colorList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)]) {
    let categories: [ProductCategoryModel] = categoryList.map{ProductCategoryModel(id: $0.id, title: $0.name)}
    let colors: [ProductColorModel] = colorList.map{ProductColorModel(name: $0.name, image: Util.getColorImage(id: $0.id), id: $0.id)}
    self.selectedFilterInProductMood.updateFilterStream(categories: categories, colors: colors)
  }
  
  func showCategoryColorModalVC() {
    router?.attachCategoryColorModalVC()
  }
  
  func dismissCategoryColorModalVC() {
    router?.detachCategoryColorModalVC()
  }
}
