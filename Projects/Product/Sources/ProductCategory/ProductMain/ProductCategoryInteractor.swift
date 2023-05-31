//
//  ProductCategoryInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import Foundation

import Util

import RIBs
import RxSwift
import RxRelay
import Networking
import Entity

protocol ProductCategoryRouting: ViewableRouting {
  func attachProductCategoryDetailVC()
  func detachProductCategoryDetailVC(with popType: PopType)
  
  func attachProductMoodDetailVC()
  func detachProductMoodDetailVC(with popType: PopType)
}

protocol ProductCategoryPresentable: Presentable {
  var listener: ProductCategoryPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProductCategoryListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProductCategoryInteractor: PresentableInteractor<ProductCategoryPresentable>, ProductCategoryInteractable, ProductCategoryPresentableListener {
  
  weak var router: ProductCategoryRouting?
  weak var listener: ProductCategoryListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let productRepository: ProductRepository
  
  var productCategorySections: BehaviorRelay<[ProductCategorySection]> = .init(value: [])
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  init(
    presenter: ProductCategoryPresentable,
    productRepository: ProductRepository
  ) {
    self.productRepository = productRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    
    Task.detached(priority: .background) { [weak self] in
      guard let self else { return }
      await self.fetchProductCategoryAPI()
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchProductCategoryAPI() async {
    let productCategoryList = Observable.just(await productRepository.getProductCategoryList())
    let productMoodList = Observable.just(await productRepository.getProductMoodList())
    
    Observable.zip(productCategoryList, productMoodList)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] categoryList, moodList in
        guard let self else { return }
        
        if let categoryList,
           let moodList {
          
          let category: ProductCategorySection = ProductCategorySection(model: "카테고리별", items: categoryList.map{ProductCategoryModel(id: $0.id, title: $0.categoryName)})
          let mood: ProductCategorySection = ProductCategorySection(model: "무드별", items: moodList.map{ProductCategoryModel(id: $0.id, title: $0.name, imageURL: $0.url)})
          
          self.productCategorySections.accept([category, mood])
        }
      }).disposed(by: disposeBag)
  }
  
  func pushProductCategoryDetailVC() {
    router?.attachProductCategoryDetailVC()
  }
  
  func popProductCategoryDetailVC(with popType: PopType) {
    router?.detachProductCategoryDetailVC(with: popType)
  }
  
  func pushProductMoodDetailVC() {
    router?.attachProductMoodDetailVC()
  }
  
  func popProductMoodDetailVC(with popType: PopType) {
    router?.detachProductMoodDetailVC(with: popType)
  }
}
