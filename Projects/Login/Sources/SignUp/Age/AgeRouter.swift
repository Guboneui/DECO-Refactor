//
//  AgeRouter.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import Util

protocol AgeInteractable:
  Interactable,
  MoodListener
{
  var router: AgeRouting? { get set }
  var listener: AgeListener? { get set }
}

protocol AgeViewControllable: ViewControllable {

}

final class AgeRouter: ViewableRouter<AgeInteractable, AgeViewControllable>, AgeRouting {
  
  private let moodBuildable: MoodBuildable
  private var moodRouting: Routing?
  
  init(
    interactor: AgeInteractable,
    viewController: AgeViewControllable,
    moodBuildable: MoodBuildable
  ) {
    self.moodBuildable = moodBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachMoodVC() {
    if moodRouting != nil { return }
    let router = moodBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.moodRouting = router
  }
  
  func detachMoodVC(with popType: PopType) {
    guard let router = moodRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    detachChild(router)
    moodRouting = nil
  }
}
