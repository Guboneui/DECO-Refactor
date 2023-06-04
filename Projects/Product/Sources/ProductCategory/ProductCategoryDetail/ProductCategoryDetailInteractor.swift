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

import RIBs
import RxSwift
import RxRelay

protocol ProductCategoryDetailRouting: ViewableRouting {
  func attachCategoryModalVC()
  func detachCategoryModalVC()
  
  func attachMoodColorModalVC()
  func detachMoodColorModalVC()
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
  var selectedFilter: BehaviorRelay<[(name: String, id: Int, isSelected: Bool)]> = .init(value: [])
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let userManager: MutableUserManagerStream
  private let productRepository: ProductRepository
  private let selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  
  init(
    presenter: ProductCategoryDetailPresentable,
    productRepository: ProductRepository,
    userManager: MutableUserManagerStream,
    selectedFilterInProductCategory: MutableSelectedFilterInProductCategoryStream
  ) {
    self.userManager = userManager
    self.productRepository = productRepository
    self.selectedFilterInProductCategory = selectedFilterInProductCategory
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    setupBindingSelectedFilter()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func setupBindingSelectedFilter() {
    self.selectedFilterInProductCategory.selectedFilter
      .observe(on: MainScheduler.instance)
      .map{$0.selectedCategory}
      .compactMap{$0}
      .subscribe(onNext: { [weak self] category in
        guard let self else { return }
        self.presenter.setCurrentCategory(category: category.title)
      }).disposed(by: disposeBag)
    
    self.selectedFilterInProductCategory.selectedFilter
      .subscribe(onNext: { [weak self] filter in
        guard let self else { return }
        
        let moods: [(String, Int, Bool)] = filter.selectedMoods.map{($0.title, $0.id, true)}
        let colors: [(String, Int, Bool)] = filter.selectedColors.map{($0.name, $0.id, true)}
        
        if (moods + colors).isEmpty {
          self.selectedFilter.accept(moods + colors)
        } else {
          self.selectedFilter.accept([("초기화", -1, false)] + moods + colors)
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
            inSelf.productLists.accept(productList)
          }
        }
      }).disposed(by: disposeBag)
  }
  
  func popProductCategoryDetailDetailVC(with popType: PopType) {
    listener?.popProductCategoryDetailVC(with: popType)
  }
  
  func fetchProductList(createdAt: Int) {
    selectedFilterInProductCategory.selectedFilter
      .subscribe(onNext: {
        print($0.selectedCategory)

      }).disposed(by: disposeBag)
    
//    Task.detached { [weak self] in
//      guard let self else { return }
//      if let productList = await self.productRepository.getProductOfCategory(
//        param:
//          ItemFilterRequest(
//            userId: self.userManager.userID,
//            itemCategoryIds: [self.itemCategoryId],
//            colorIds: [],
//            styleIds: [],
//            createdAt: createdAt,
//            name: "")
//      ) {
//        self.productLists.accept(productList)
//      }
//    }
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
}
