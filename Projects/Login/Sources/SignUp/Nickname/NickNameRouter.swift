//
//  NickNameRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import UIKit
import Util

protocol NickNameInteractable:
  Interactable,
  GenderListener
{
  var router: NickNameRouting? { get set }
  var listener: NickNameListener? { get set }
  
}

protocol NickNameViewControllable: ViewControllable {

}

final class NickNameRouter:
  ViewableRouter<NickNameInteractable, NickNameViewControllable>,
  NickNameRouting
{
  
  private let genderBuildable: GenderBuildable
  private var genderRouting: Routing?
  
  init(
    interactor: NickNameInteractable,
    viewController: NickNameViewControllable,
    genderBuildable: GenderBuildable
  ) {
    self.genderBuildable = genderBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  // MARK: - NickNameRouting
  func attachGenderVC() {
    if genderRouting != nil { return }
    let router = genderBuildable.build(withListener: interactor)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.genderRouting = router
  }
  
  func detachGenderVC(with popType: PopType) {
    guard let router = genderRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    detachChild(router)
    genderRouting = nil
  }
}
