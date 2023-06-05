//
//  SelectedFilterInProductMoodStream.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import Foundation

import Util

import RxSwift
import RxRelay

struct SelectedFilterInProductMoodStreamModel {
  let selectedMood: ProductCategoryModel?
  let selectedCategories: [ProductCategoryModel]
  let selectedColors: [ProductColorModel]
}

protocol SelectedFilterInProductMoodStream: AnyObject {
  var selectedFilter: Observable<SelectedFilterInProductMoodStreamModel> { get }
}

protocol MutableSelectedFilterInProductMoodStream: SelectedFilterInProductMoodStream {
  var productCategoryList: [ProductCategoryModel] { get }
  var productMoodList: [ProductCategoryModel] { get }
  func setProductCategoryList(categoryList: [ProductCategoryModel])
  func setProductMoodList(moodList: [ProductCategoryModel])
  func updateSelectedMood(mood: ProductCategoryModel)
  func updateSelectedCategories(categories: [ProductCategoryModel])
  func updateSelectedColors(colors: [ProductColorModel])
  func updateFilterStream(categories: [ProductCategoryModel], colors: [ProductColorModel])
}

class SelectedFilterInProductMoodStreamImpl: MutableSelectedFilterInProductMoodStream {
  
  var productCategoryList: [ProductCategoryModel] = []
  var productMoodList: [ProductCategoryModel] = []
  
  private let filter = BehaviorRelay<SelectedFilterInProductMoodStreamModel>(
    value: SelectedFilterInProductMoodStreamModel(
      selectedMood: nil,
      selectedCategories: [],
      selectedColors: []
    )
  )
  
  var selectedFilter: RxSwift.Observable<SelectedFilterInProductMoodStreamModel> {
    return filter.asObservable()
  }
  
  func setProductCategoryList(categoryList: [ProductCategoryModel]) {
    productCategoryList = categoryList
  }
  
  func setProductMoodList(moodList: [ProductCategoryModel]) {
    productMoodList = moodList
  }
  
  func updateSelectedMood(mood: ProductCategoryModel) {
    let updatedInfo: SelectedFilterInProductMoodStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductMoodStreamModel (
        selectedMood: mood,
        selectedCategories: currentInfo.selectedCategories,
        selectedColors: currentInfo.selectedColors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateSelectedCategories(categories: [ProductCategoryModel]) {
    let updatedInfo: SelectedFilterInProductMoodStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductMoodStreamModel (
        selectedMood: currentInfo.selectedMood,
        selectedCategories: categories,
        selectedColors: currentInfo.selectedColors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateSelectedColors(colors: [Util.ProductColorModel]) {
    let updatedInfo: SelectedFilterInProductMoodStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductMoodStreamModel (
        selectedMood: currentInfo.selectedMood,
        selectedCategories: currentInfo.selectedCategories,
        selectedColors: colors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateFilterStream(categories: [ProductCategoryModel], colors: [Util.ProductColorModel]) {
    let updatedInfo: SelectedFilterInProductMoodStreamModel = {
      let currentInfo = filter.value
      return SelectedFilterInProductMoodStreamModel (
        selectedMood: currentInfo.selectedMood,
        selectedCategories: categories,
        selectedColors: colors
      )
    }()
    filter.accept(updatedInfo)
  }
}

