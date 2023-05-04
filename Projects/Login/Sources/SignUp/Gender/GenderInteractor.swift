//
//  GenderInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import Util

enum GenderType {
  case Woman
  case Man
  case None
}

protocol GenderRouting: ViewableRouting {
  func attachAgeVC()
  func detachAgeVC(with popType: PopType)
}

protocol GenderPresentable: Presentable {
  var listener: GenderPresentableListener? { get set }
}

protocol GenderListener: AnyObject {
  func detachGenderVC(with popType: PopType)
}

final class GenderInteractor: PresentableInteractor<GenderPresentable>, GenderInteractable, GenderPresentableListener {
  
  weak var router: GenderRouting?
  weak var listener: GenderListener?
  
  var selectedGenderType: PublishSubject<GenderType> = .init()
  
  override init(presenter: GenderPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func popGenderVC(with popType: PopType) {
    listener?.detachGenderVC(with: popType)
  }
  
  func pushAgeVC() {
    router?.attachAgeVC()
  }
  
  func detachAgeVC(with popType: PopType) {
    router?.detachAgeVC(with: popType)
  }
  
  
  func checkedGender(gender: GenderType) {
    selectedGenderType.onNext(gender)
  }
}
