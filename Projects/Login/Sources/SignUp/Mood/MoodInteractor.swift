//
//  MoodInteractor.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import RxRelay
import Util
import UIKit
import CommonUI
import Networking
import Entity

protocol MoodRouting: ViewableRouting {
  func signUp()
}

protocol MoodPresentable: Presentable {
  var listener: MoodPresentableListener? { get set }
  func set(nickname: String)
}

protocol MoodListener: AnyObject {
  func detachMoodVC(with popType: PopType)
  func didSelectedMoods(moods: [Int])
}

final class MoodInteractor: PresentableInteractor<MoodPresentable>, MoodInteractable, MoodPresentableListener {
  
  weak var router: MoodRouting?
  weak var listener: MoodListener?
  
  var moods: BehaviorRelay<[(styleInfo: StyleModel, isSelected: Bool)]> = .init(value: [
    (StyleModel(id: 9, image: .DecoImage.simple), false),
    (StyleModel(id: 10, image: .DecoImage.vintage), false),
    (StyleModel(id: 12, image: .DecoImage.kitch), false),
    (StyleModel(id: 13, image: .DecoImage.sense), false),
    (StyleModel(id: 17, image: .DecoImage.cute), false)
  ])
  private let userSignUpInfoStream: MutableSignUpStream
  
  init(presenter: MoodPresentable,
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
  
  private func filteredSelectedMoods() -> [Int] {
    let filteredMoods = moods.value.filter{$0.isSelected}.map{$0.styleInfo.id}
    return filteredMoods
  }
  
  // MARK: - MoodPresentableListener
  func popMoodVC(with popType: PopType) {
    userSignUpInfoStream.updateMoods(moods: nil)
    self.listener?.detachMoodVC(with: popType)
  }
  
  func update(index: Int) {
    let selectedData: (styleInfo: StyleModel, isSelected: Bool) = moods.value[index]
    let changedData: (StyleModel, Bool) = (selectedData.styleInfo, !selectedData.isSelected)
    var newValue = moods.value
    newValue[index] = changedData
    moods.accept(newValue)
  }
  
  func signUpDidTap() {
    let selectedMoods = filteredSelectedMoods()
    listener?.didSelectedMoods(moods: selectedMoods)
    router?.signUp()
  }
  
  // MARK: - 
}
