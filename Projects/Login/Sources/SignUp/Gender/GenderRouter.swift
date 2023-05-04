//
//  GenderRouter.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import Util

protocol GenderInteractable:
  Interactable,
  AgeListener
{
  var router: GenderRouting? { get set }
  var listener: GenderListener? { get set }
}

protocol GenderViewControllable: ViewControllable {

}

final class GenderRouter: ViewableRouter<GenderInteractable, GenderViewControllable>, GenderRouting {
  
  private let ageBuildable: AgeBuildable
  private var ageRouting: Routing?
  
  init(
    interactor: GenderInteractable,
    viewController: GenderViewControllable,
    ageBuildable: AgeBuildable
  ) {
    self.ageBuildable = ageBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachAgeVC() {
    if ageRouting != nil { return }
    let router = ageBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.ageRouting = router
  }
  
  func detachAgeVC(with popType: PopType) {
    guard let router = ageRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    detachChild(router)
    ageRouting = nil
  }
}
