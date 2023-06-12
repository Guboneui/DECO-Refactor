//
//  SearchPhotoInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import User
import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol SearchPhotoRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchPhotoPresentable: Presentable {
  var listener: SearchPhotoPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchPhotoListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchPhotoInteractor: PresentableInteractor<SearchPhotoPresentable>, SearchPhotoInteractable, SearchPhotoPresentableListener {
  
  weak var router: SearchPhotoRouting?
  weak var listener: SearchPhotoListener?
  
  private let searchText: String
  private let searchRepository: SearchRepository
  private let userManager: MutableUserManagerStream
  
  var photoList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: SearchPhotoPresentable,
    searchText: String,
    searchRepository: SearchRepository,
    userManager: MutableUserManagerStream
  ) {
    self.searchText = searchText
    self.searchRepository = searchRepository
    self.userManager = userManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchPhotoList(createdAt: Int.max)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchPhotoList(createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let photoList = await self.searchRepository.getSearchPhotoList(
        param: BoardFilterRequest(
          offset: createdAt,
          listType: "SEARCH",
          keyword: self.searchText,
          styleIds: [],
          colorIds: [],
          boardCategoryIds: [],
          userId: self.userManager.userID)
      ), !photoList.isEmpty {
        let prevData = self.photoList.value
        self.photoList.accept(prevData + photoList)
      }
    }
  }
}
