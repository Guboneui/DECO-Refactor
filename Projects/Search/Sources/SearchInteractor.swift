//
//  SearchInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import Util

import Foundation

import RIBs
import RxSwift
import RxRelay

public protocol SearchRouting: ViewableRouting {
  func attachSearchResultVC(with searchText: String)
  func detachSearchResultVC(with popType: PopType)
}

protocol SearchPresentable: Presentable {
  var listener: SearchPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol SearchListener: AnyObject {
  func popSearchVC(with popType: PopType)
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
  
  weak var router: SearchRouting?
  weak var listener: SearchListener?
  
  var searchHistory: BehaviorRelay<[String]> = .init(value: [])
  
  override init(presenter: SearchPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.getUserSearchHistory()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popSearchVC(with popType: PopType) {
    listener?.popSearchVC(with: popType)
  }
  
  func pushSearchResultVC(with searchText: String) {
    router?.attachSearchResultVC(with: searchText)
  }
  
  func popSearchResultVC(with popType: PopType) {
    router?.detachSearchResultVC(with: popType)
  }
  
  func searchText(with keyword: String) {
    UserDefaults().updateSearchHistoryValue(with: keyword)
    getUserSearchHistory()
  }
  
  private func getUserSearchHistory() {
    let searchHistory = UserDefaults().getSearchHistoryValue()
    self.searchHistory.accept(searchHistory)
  }
}
