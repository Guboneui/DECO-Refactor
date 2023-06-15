//
//  SearchBrandInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol SearchBrandRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchBrandPresentable: Presentable {
  var listener: SearchBrandPresentableListener? { get set }
  @MainActor func showEmptyNotice()
}

protocol SearchBrandListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchBrandInteractor: PresentableInteractor<SearchBrandPresentable>, SearchBrandInteractable, SearchBrandPresentableListener {
  
  weak var router: SearchBrandRouting?
  weak var listener: SearchBrandListener?
  
  private let searchText: String
  private let searchRepository: SearchRepository
  
  var brandList: BehaviorRelay<[BrandDTO]> = .init(value: [])
  
  init(
    presenter: SearchBrandPresentable,
    searchText: String,
    searchRepository: SearchRepository
  ) {
    self.searchText = searchText
    self.searchRepository = searchRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchBrandListWithSearchText(with: searchText)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchBrandListWithSearchText(with searchText: String) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let brandList = await self.searchRepository.getSearchBrandList(brandName: searchText) {
        self.brandList.accept(brandList)
        
        if brandList.isEmpty {
          await presenter.showEmptyNotice()
        }
      }
    }
  }
}

