//
//  AgeInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import Util

protocol AgeRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AgePresentable: Presentable {
  var listener: AgePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AgeListener: AnyObject {
  func detachAgeVC(with popType: PopType)
  func attachMoodVC()
}

final class AgeInteractor: PresentableInteractor<AgePresentable>, AgeInteractable, AgePresentableListener {
  
  weak var router: AgeRouting?
  weak var listener: AgeListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: AgePresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popAgeVC(with popType: PopType) {
    self.listener?.detachAgeVC(with: popType)
  }
  
  func pushMoodVC() {
    self.listener?.attachMoodVC()
  }
}
