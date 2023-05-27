//
//  ProfileInteractor.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import Entity
import Networking

import RIBs
import RxSwift
import RxRelay

public protocol ProfileRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfilePresentable: Presentable {
  var listener: ProfilePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol ProfileListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable, ProfilePresentableListener {
  
  weak var router: ProfileRouting?
  weak var listener: ProfileListener?
  
  private let userProfileRepository: UserProfileRepository
  var userPostings: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  init(
    presenter: ProfilePresentable,
    userProfileRepository: UserProfileRepository
  ) {
    self.userProfileRepository = userProfileRepository
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.fetchUserPostings(id: 72, userID: 72, createdAt: Int.max)
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func fetchUserPostings(id: Int, userID: Int, createdAt: Int) {
    Task.detached { [weak self] in
      guard let self else { return }
      let postings = await self.userProfileRepository.userPostings(id: id, userID: userID, createdAt: createdAt)
      let prevData = self.userPostings.value
      if let postings, !postings.isEmpty {
        self.userPostings.accept(prevData + postings)
      }
    }
  }
}
