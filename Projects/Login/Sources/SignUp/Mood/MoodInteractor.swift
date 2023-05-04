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
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MoodPresentable: Presentable {
  var listener: MoodPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MoodListener: AnyObject {
  func detachMoodVC(with popType: PopType)
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
  
  func update(index: Int) {
    let selectedData: (styleInfo: StyleModel, isSelected: Bool) = moods.value[index]
    let changedData: (StyleModel, Bool) = (selectedData.styleInfo, !selectedData.isSelected)
    var newValue = moods.value
    newValue[index] = changedData
    moods.accept(newValue)
  }
  
  func signUp() {
    let filteredData = moods.value.filter{$0.isSelected}
    print(filteredData)
//    print(filteredData.count)
  }
  
  func popMoodVC(with popType: PopType) {
    listener?.detachMoodVC(with: popType)
  }
}
