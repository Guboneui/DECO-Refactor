//
//  SearchPhotoFilterStream.swift
//  Search
//
//  Created by 구본의 on 2023/06/16.
//

import Foundation

import Util
import Entity

import RxSwift
import RxRelay

public enum SearchPhotoFilterType {
  case Board
  case Mood
  case Color
  case None
}

struct SearchPhotoFilterStreamModel {
  let selectedCategory: [BoardCategoryDTO]
  let selectedMood: [ProductMoodDTO]
  let selectedColors: [ProductColorModel]
}

protocol SearchPhotoFilterStream: AnyObject {
  var selectedFilter: Observable<SearchPhotoFilterStreamModel> { get }
}

protocol MutableSearchPhotoFilterStream: SearchPhotoFilterStream {
  var categoryList: [BoardCategoryDTO] { get }
  var moodList: [ProductMoodDTO] { get }
  var colorList: [ProductColorModel] { get }
  
  func setCategoryFilterData(categoryData: [BoardCategoryDTO])
  func setMoodFilterData(moodData: [ProductMoodDTO])
  func setColorFilterData(colorData: [ProductColorModel])
  
  func updateCategoryFilterData(categoryData: [BoardCategoryDTO])
  func updateMoodFilterData(moodData: [ProductMoodDTO])
  func updateColorFilterData(colorData: [ProductColorModel])
  
  func updateFilterStream(
    category: [BoardCategoryDTO],
    mood: [ProductMoodDTO],
    color: [ProductColorModel]
  )
}

class SearchPhotoFilterStreamImpl: MutableSearchPhotoFilterStream {
  
  init() {}
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let filter = BehaviorRelay<SearchPhotoFilterStreamModel>(
    value: SearchPhotoFilterStreamModel(
      selectedCategory: [],
      selectedMood: [],
      selectedColors: []
    )
  )
  
  var selectedFilter: Observable<SearchPhotoFilterStreamModel> {
    return filter.asObservable()
  }
  
  var categoryList: [BoardCategoryDTO] = []
  var moodList: [ProductMoodDTO] = []
  var colorList: [ProductColorModel] = []
  
  func setCategoryFilterData(categoryData: [Entity.BoardCategoryDTO]) {
    categoryList = categoryData
    
  }
  
  func setMoodFilterData(moodData: [Entity.ProductMoodDTO]) {
    moodList = moodData
  }
  
  func setColorFilterData(colorData: [Util.ProductColorModel]) {
    colorList = colorData
  }
  
  func updateCategoryFilterData(categoryData: [Entity.BoardCategoryDTO]) {
    let updatedInfo: SearchPhotoFilterStreamModel = {
      let currentInfo = filter.value
      return SearchPhotoFilterStreamModel(
        selectedCategory: categoryData,
        selectedMood: currentInfo.selectedMood,
        selectedColors: currentInfo.selectedColors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateMoodFilterData(moodData: [Entity.ProductMoodDTO]) {
    let updatedInfo: SearchPhotoFilterStreamModel = {
      let currentInfo = filter.value
      return SearchPhotoFilterStreamModel(
        selectedCategory: currentInfo.selectedCategory,
        selectedMood: moodData,
        selectedColors: currentInfo.selectedColors
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateColorFilterData(colorData: [Util.ProductColorModel]) {
    let updatedInfo: SearchPhotoFilterStreamModel = {
      let currentInfo = filter.value
      return SearchPhotoFilterStreamModel(
        selectedCategory: currentInfo.selectedCategory,
        selectedMood: currentInfo.selectedMood,
        selectedColors: colorData
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func updateFilterStream(category: [Entity.BoardCategoryDTO], mood: [Entity.ProductMoodDTO], color: [Util.ProductColorModel]) {
    let updateFilter: SearchPhotoFilterStreamModel = SearchPhotoFilterStreamModel(
      selectedCategory: category,
      selectedMood: mood,
      selectedColors: color
    )
    filter.accept(updateFilter)
  }
}
