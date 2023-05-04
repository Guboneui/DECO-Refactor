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

}

protocol MoodPresentable: Presentable {
  var listener: MoodPresentableListener? { get set }
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
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func popMoodVC(with popType: PopType) {
    self.listener?.detachMoodVC(with: popType)
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
  }
}
