//
//  SelectedFilterInProductCategoryStream.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import Foundation

import RxSwift
import RxRelay

struct SelectedFilterInProductCategoryStreamModel {
  let selectedCategory: ProductCategoryModel?
  let selectedMoods: [ProductCategoryModel]
  let selectedColors: [(colorId: Int, colorName: String)]
}

protocol SelectedFilterInProductCategoryStream: AnyObject {
  var selectedFilter: Observable<SelectedFilterInProductCategoryStreamModel> { get }
}

protocol MutableSelectedFilterInProductCategoryStream: SelectedFilterInProductCategoryStream {
  var productCategoryList: [ProductCategoryModel] { get }
  var productMoodList: [ProductCategoryModel] { get }
  func setProductCategoryList(categoryList: [ProductCategoryModel])
  func setProductMoodList(moodList: [ProductCategoryModel])
  func updateSelectedCategory(category: ProductCategoryModel)
  func updateSelectedMoods(mood: [ProductCategoryModel])
  func updateSelectedColors(colors: [(colorId: Int, colorName: String)])
}

class SelectedFilterInProductCategoryStreamImpl: MutableSelectedFilterInProductCategoryStream {
  
  init() {}
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  var productCategoryList: [ProductCategoryModel] = []
  var productMoodList: [ProductCategoryModel] = []
  private let filter = BehaviorRelay<SelectedFilterInProductCategoryStreamModel>(
    value: SelectedFilterInProductCategoryStreamModel(
      selectedCategory: nil,
      selectedMoods: [],
      selectedColors: []
    )
  )
  
  var selectedFilter: Observable<SelectedFilterInProductCategoryStreamModel> {
    return filter.asObservable()
  }
  
  func setProductCategoryList(categoryList: [ProductCategoryModel]) {
    productCategoryList = categoryList
  }
  
  func setProductMoodList(moodList: [ProductCategoryModel]) {
    productMoodList = moodList
  }
  
  func updateSelectedCategory(category: ProductCategoryModel) {
    let updatedInfo: SelectedFilterInProductCategoryStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductCategoryStreamModel(
        selectedCategory: category,
        selectedMoods: currentInfo.selectedMoods,
        selectedColors: currentInfo.selectedColors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateSelectedMoods(mood: [ProductCategoryModel]) {
    let updatedInfo: SelectedFilterInProductCategoryStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductCategoryStreamModel(
        selectedCategory: currentInfo.selectedCategory,
        selectedMoods: mood,
        selectedColors: currentInfo.selectedColors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateSelectedColors(colors: [(colorId: Int, colorName: String)]) {
    let updatedInfo: SelectedFilterInProductCategoryStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductCategoryStreamModel(
        selectedCategory: currentInfo.selectedCategory,
        selectedMoods: currentInfo.selectedMoods,
        selectedColors: colors
      )
    }()
    filter.accept(updatedInfo)
  }
}
