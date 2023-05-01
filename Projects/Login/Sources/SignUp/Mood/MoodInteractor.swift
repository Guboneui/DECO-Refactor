//
//  MoodInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift

protocol MoodRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MoodPresentable: Presentable {
  var listener: MoodPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MoodListener: AnyObject {
  func detachMoodVC()
}

final class MoodInteractor: PresentableInteractor<MoodPresentable>, MoodInteractable, MoodPresentableListener {
  
  weak var router: MoodRouting?
  weak var listener: MoodListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: MoodPresentable) {
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
  
  func popMoodVC() {
    listener?.detachMoodVC()
  }
}
