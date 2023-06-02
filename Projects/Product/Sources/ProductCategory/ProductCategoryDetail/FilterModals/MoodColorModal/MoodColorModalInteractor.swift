//
//  MoodColorModalInteractor.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift

protocol MoodColorModalRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MoodColorModalPresentable: Presentable {
  var listener: MoodColorModalPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MoodColorModalListener: AnyObject {
  func dismissMoodColorModalVC()
}

final class MoodColorModalInteractor: PresentableInteractor<MoodColorModalPresentable>, MoodColorModalInteractable, MoodColorModalPresentableListener {
  
  
  
  weak var router: MoodColorModalRouting?
  weak var listener: MoodColorModalListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: MoodColorModalPresentable) {
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
  
  func dismissMoodColorModalVC() {
    self.listener?.dismissMoodColorModalVC()
  }
}
