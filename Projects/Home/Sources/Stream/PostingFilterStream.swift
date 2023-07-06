//
//  PostingFilterStream.swift
//  Home
//
//  Created by 구본의 on 2023/07/05.
//

import Foundation

import Util

import RxSwift
import RxRelay

enum PostingCategory {
  case Board
  case Style
  case All
}

struct PostingCategoryModel {
  let name: String
  let id: Int
  let type: PostingCategory
}

struct SelectedPostingFilterStreamModel {
  let selectedBoardCategory: [PostingCategoryModel]
  let selectedStyleCategory: [PostingCategoryModel]
}

protocol SelectedPostingFilterStream: AnyObject {
  var selectedFilter: Observable<SelectedPostingFilterStreamModel> { get }
}

protocol MutableSelectedPostingFilterStream: SelectedPostingFilterStream {
  func updateFilterStream(boardCategoryList: [PostingCategoryModel], styleCategoryList: [PostingCategoryModel])
  func clearStream()
}

class SelectedPostingFilterStreamImpl: MutableSelectedPostingFilterStream {
  
  private let filter = BehaviorRelay<SelectedPostingFilterStreamModel> (
    value: SelectedPostingFilterStreamModel(
      selectedBoardCategory: [],
      selectedStyleCategory: []
    )
  )
  
  var selectedFilter: RxSwift.Observable<SelectedPostingFilterStreamModel> {
    return filter.asObservable()
  }
  
  func updateFilterStream(boardCategoryList: [PostingCategoryModel], styleCategoryList: [PostingCategoryModel]) {
    let updatedInfo: SelectedPostingFilterStreamModel = {
      return SelectedPostingFilterStreamModel(
        selectedBoardCategory: boardCategoryList,
        selectedStyleCategory: styleCategoryList
      )
    }()
    filter.accept(updatedInfo)
  }
  
  func clearStream() {
    let clearData: SelectedPostingFilterStreamModel = {
      return SelectedPostingFilterStreamModel (
        selectedBoardCategory: [],
        selectedStyleCategory: []
      )
    }()
    filter.accept(clearData)
  }
}
