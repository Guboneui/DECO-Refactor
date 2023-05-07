//
//  GenderInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import RxRelay
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
  func set(nickname: String)
}

protocol GenderListener: AnyObject {
  func detachGenderVC(with popType: PopType)
  func didSelectedGender(gender: GenderType)
}

final class GenderInteractor: PresentableInteractor<GenderPresentable>, GenderInteractable, GenderPresentableListener {
  
  
  
  weak var router: GenderRouting?
  weak var listener: GenderListener?
  
  var selectedGenderType: BehaviorRelay<GenderType?> = .init(value: nil)
  private let userSignUpInfoStream: MutableSignUpStream
  
  init(presenter: GenderPresentable,
       signUpInfo: MutableSignUpStream
  ) {
    self.userSignUpInfoStream = signUpInfo
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.showUserNickname()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  private func showUserNickname() {
    userSignUpInfoStream.signupInfo
      .compactMap{$0.nickname}
      .subscribe(onNext: { [weak self] (nickname: String) in
        guard let self else { return }
        self.presenter.set(nickname: nickname)
      }).disposeOnDeactivate(interactor: self)
  }
  
  func popGenderVC(with popType: PopType) {
    userSignUpInfoStream.updateGender(gender: nil)
    listener?.detachGenderVC(with: popType)
  }
  
  func pushAgeVC() {
    if let gender = selectedGenderType.value {
      listener?.didSelectedGender(gender: gender)
      router?.attachAgeVC()
    }
  }
  
  func checkedGender(gender: GenderType) {
    selectedGenderType.accept(gender)
  }
  
  // MARK: - Age Listener
  func detachAgeVC(with popType: PopType) {
    router?.detachAgeVC(with: popType)
  }
  
  func didSelectedAge(age: AgeType) {
    userSignUpInfoStream.updateAge(age: age)
  }
}
