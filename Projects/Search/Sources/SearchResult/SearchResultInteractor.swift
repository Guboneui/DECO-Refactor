//
//  SearchResultInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Util
import Entity

import RIBs
import RxSwift
import RxRelay

enum SearchTab {
  case Photo
  case Product
  case Brand
  case User
}

protocol SearchResultRouting: ViewableRouting {
  func attachProductDetailVC(with productInfo: ProductDTO)
  func detachProductDetailVC(with popType: PopType)
}

protocol SearchResultPresentable: Presentable {
  var listener: SearchResultPresentableListener? { get set }
  func setSearchTextLabel(with searchText: String)
}

protocol SearchResultListener: AnyObject {
  func popSearchResultVC(with popType: PopType)
}

final class SearchResultInteractor: PresentableInteractor<SearchResultPresentable>, SearchResultInteractable, SearchResultPresentableListener {
  
  weak var router: SearchResultRouting?
  weak var listener: SearchResultListener?
  
  var currentTab: BehaviorRelay<SearchTab> = .init(value: .Photo)
  
  private let searchText: String
  
  init(
    presenter: SearchResultPresentable,
    searchText: String
  ) {
    self.searchText = searchText
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.presenter.setSearchTextLabel(with: self.searchText)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popSearchResultVC(with popType: PopType) {
    listener?.popSearchResultVC(with: popType)
  }
  
  func pushProductDetailVC(with productInfo: ProductDTO) {
    router?.attachProductDetailVC(with: productInfo)
  }
  
  func popProductDetailVC(with popType: Util.PopType) {
    router?.detachProductDetailVC(with: popType)
  }
}
