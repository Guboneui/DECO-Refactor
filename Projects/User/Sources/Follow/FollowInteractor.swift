//
//  FollowInteractor.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Util

import RIBs
import RxSwift
import RxRelay

public enum FollowTabType {
  case Follower
  case Following
}

public protocol FollowRouting: ViewableRouting {
  
}

protocol FollowPresentable: Presentable {
  var listener: FollowPresentableListener? { get set }
  func setNavTitle(with title: String)
}

public protocol FollowListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
  func detachFollowVC(with popType: PopType)
}

final class FollowInteractor: PresentableInteractor<FollowPresentable>, FollowInteractable, FollowPresentableListener {
  
  weak var router: FollowRouting?
  weak var listener: FollowListener?
  var followerListViewControllerable: ViewControllable?
  var followingListViewControllerable: ViewControllable?
  
  var followVCs: BehaviorRelay<[ViewControllable]> = .init(value: [])
  var currentFollowTab: BehaviorRelay<FollowTabType> = .init(value: .Follower)
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let userManager: MutableUserManagerStream
  
  init(
    presenter: FollowPresentable,
    userManager: MutableUserManagerStream
  ) {
    self.userManager = userManager
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    if let followerListViewControllerable,
       let followingListViewControllerable {
      self.followVCs.accept([followerListViewControllerable, followingListViewControllerable])
    }
    self.setupBindings()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  private func setupBindings() {
    self.userManager.userInfo
      .map{$0.nickname}
      .subscribe(onNext: { [weak self] nickname in
        guard let self else { return }
        self.presenter.setNavTitle(with: nickname)
      }).disposed(by: disposeBag)
  }
  
  func popFollowVC(with popType: PopType) {
    self.listener?.detachFollowVC(with: popType)
  }
}
