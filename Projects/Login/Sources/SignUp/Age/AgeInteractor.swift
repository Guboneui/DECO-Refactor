//
//  AgeInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import Util

enum AgeType {
  case More
  case Less
}

protocol AgeRouting: ViewableRouting {
  func attachMoodVC()
  func detachMoodVC(with popType: PopType)
}

protocol AgePresentable: Presentable {
  var listener: AgePresentableListener? { get set }
}

protocol AgeListener: AnyObject {
  func detachAgeVC(with popType: PopType)
  
}

final class AgeInteractor: PresentableInteractor<AgePresentable>, AgeInteractable, AgePresentableListener {
  
  weak var router: AgeRouting?
  weak var listener: AgeListener?
  
  var selectedAgeType: PublishSubject<AgeType> = .init()
  
  override init(presenter: AgePresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()

  }
  
  override func willResignActive() {
    super.willResignActive()

  }
  
  func popAgeVC(with popType: PopType) {
    self.listener?.detachAgeVC(with: popType)
  }
  
  func pushMoodVC() {
    self.router?.attachMoodVC()
  }
  
  func detachMoodVC(with popType: PopType) {
    self.router?.detachMoodVC(with: popType)
  }
  
  func checkedAge(ageType: AgeType) {
    self.selectedAgeType.onNext(ageType)
  }
}
