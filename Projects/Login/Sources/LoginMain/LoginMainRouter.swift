//
//  LoginMainRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit

protocol LoginMainInteractable:
  Interactable,
  NickNameListener,
  GenderListener,
  AgeListener,
  MoodListener
{
  var router: LoginMainRouting? { get set }
  var listener: LoginMainListener? { get set }
}

public protocol LoginMainViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class LoginMainRouter: ViewableRouter<LoginMainInteractable, NavigationControllerable>, LoginMainRouting {
  
  private var navigationControllable: NavigationControllerable?

  private let nicknameBuildable: NickNameBuildable
  private var nicknameRouting: Routing?
  
  private let genderBuildable: GenderBuildable
  private var genderRouting: Routing?
  
  private let ageBuildable: AgeBuildable
  private var ageRouting: Routing?
  
  private let moodBuildable: MoodBuildable
  private var moodRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: LoginMainInteractable,
    navigationController: NavigationControllerable,
    nicknameBuildable: NickNameBuildable,
    genderBuildable: GenderBuildable,
    ageBuildable: AgeBuildable,
    moodBuildable: MoodBuildable
  ) {

    self.nicknameBuildable = nicknameBuildable
    self.genderBuildable = genderBuildable
    self.ageBuildable = ageBuildable
    self.moodBuildable = moodBuildable
    super.init(interactor: interactor, viewController: navigationController)
    interactor.router = self
  }
  
  func attachNicknameVC() {
    if nicknameRouting != nil { return }
    let router = nicknameBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)

    attachChild(router)
    self.nicknameRouting = router
  }
  
  func detachNicknameVC(with popType: PopType) {
    guard let router = nicknameRouting else { return }
    if popType == .BackButton {
      self.navigationControllable?.popViewController(animated: true)
    }
    detachChild(router)
    nicknameRouting = nil
  }
  
  func attachGenderVC() {
    if genderRouting != nil { return }
    let router = genderBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.genderRouting = router
  }
  
  func detachGenderVC(with popType: PopType) {
    guard let router = genderRouting else { return }
    if popType == .BackButton {
      self.navigationControllable?.popViewController(animated: true)
    }
    detachChild(router)
    genderRouting = nil
  }
  
  func attachAgeVC() {
    if ageRouting != nil { return }
    let router = ageBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.ageRouting = router
  }
  
  func detachAgeVC(with popType: PopType) {
    guard let router = ageRouting else { return }
    if popType == .BackButton {
      self.navigationControllable?.popViewController(animated: true)
    }
    detachChild(router)
    ageRouting = nil
  }
  
  func attachMoodVC() {
    if moodRouting != nil { return }
    let router = moodBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.moodRouting = router
  }
  
  func detachMoodVC(with popType: PopType) {
    guard let router = moodRouting else { return }
    if popType == .BackButton {
      self.navigationControllable?.popViewController(animated: true)
    }
    detachChild(router)
    moodRouting = nil
  }
}
