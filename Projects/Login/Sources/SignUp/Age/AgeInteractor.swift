//
//  AgeInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import RxRelay
import Util

enum AgeType {
  case Upper
  case Lower
}

protocol AgeRouting: ViewableRouting {
  func attachMoodVC()
  func detachMoodVC(with popType: PopType)
}

protocol AgePresentable: Presentable {
  var listener: AgePresentableListener? { get set }
  func set(nickname: String)
}

protocol AgeListener: AnyObject {
  func detachAgeVC(with popType: PopType)
  func didSelectedAge(age: AgeType)
  func moveToMain()
}

final class AgeInteractor: PresentableInteractor<AgePresentable>, AgeInteractable, AgePresentableListener {
  
  weak var router: AgeRouting?
  weak var listener: AgeListener?
  
  var selectedAgeType: BehaviorRelay<AgeType?> = .init(value: nil)
  private let userSignUpInfoStream: MutableSignUpStream
  
  init(presenter: AgePresentable,
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
  
  // MARK: - Private Method
  private func showUserNickname() {
    userSignUpInfoStream.signupInfo
      .compactMap{$0.nickname}
      .subscribe(onNext: { [weak self] (nickname: String) in
        guard let self else { return }
        self.presenter.set(nickname: nickname)
      }).disposeOnDeactivate(interactor: self)
  }
  
  // MARK: - AgePresentableListener
  func popAgeVC(with popType: PopType) {
    userSignUpInfoStream.updateAge(age: nil)
    self.listener?.detachAgeVC(with: popType)
  }
  
  func pushMoodVC() {
    if let age = selectedAgeType.value {
      listener?.didSelectedAge(age: age)
      router?.attachMoodVC()
    }
  }
  
  func checkedAge(ageType: AgeType) {
    self.selectedAgeType.accept(ageType)
  }
  
  // MARK: - MoodListener
  func detachMoodVC(with popType: PopType) {
    self.router?.detachMoodVC(with: popType)
  }
  
  func didSelectedMoods(moods: [Int]) {
    userSignUpInfoStream.updateMoods(moods: moods)
  }
  
  func moveToMain() {
    self.listener?.moveToMain()
  }
}
