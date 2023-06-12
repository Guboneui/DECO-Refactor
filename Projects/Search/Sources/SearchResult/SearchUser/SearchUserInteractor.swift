//
//  SearchUserInteractor.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

protocol SearchUserRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchUserPresentable: Presentable {
  var listener: SearchUserPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SearchUserListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchUserInteractor: PresentableInteractor<SearchUserPresentable>, SearchUserInteractable, SearchUserPresentableListener {
  
  weak var router: SearchUserRouting?
  weak var listener: SearchUserListener?
  
  private let searchText: String
  private let searchRepository: SearchRepository
  
  var userList: BehaviorRelay<[SearchUserDTO]> = .init(value: [])
  
  init(
    presenter: SearchUserPresentable,
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
    self.fetchUserListWithSearchText(with: searchText)
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func fetchUserListWithSearchText(with searchText: String) {
    Task.detached { [weak self] in
      guard let self else { return }
      if let userList = await self.searchRepository.getSearchUserList(nickname: searchText) {
        self.userList.accept(userList)
      }
    }
  }
}
