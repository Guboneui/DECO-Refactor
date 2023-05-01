//
//  GenderInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift

protocol GenderRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol GenderPresentable: Presentable {
  var listener: GenderPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol GenderListener: AnyObject {
  func detachGenderVC()
  func attachAgeVC()
}

final class GenderInteractor: PresentableInteractor<GenderPresentable>, GenderInteractable, GenderPresentableListener {
  
  weak var router: GenderRouting?
  weak var listener: GenderListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: GenderPresentable) {
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
  
  func popGenderVC() {
    listener?.detachGenderVC()
  }
  
  func pushAgeVC() {
    listener?.attachAgeVC()
  }
}
