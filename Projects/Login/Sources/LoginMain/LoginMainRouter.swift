//
//  LoginMainRouter.swift
//  Login
//
//  Created by 구본의 on 2023/04/23.
//

import RIBs
import Util
import UIKit


//MARK: -

public protocol NavigationControllerDelegate: AnyObject {
  //func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
  func navigationController()
}

public final class NavigationControllerDelegateProxy: NSObject, UINavigationControllerDelegate {
  public weak var delegate: NavigationControllerDelegate?
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//    delegate?.navigationController(navigationController, didShow: viewController, animated: animated)
    delegate?.navigationController()
  }
}

//MARK: -

protocol LoginMainInteractable:
  Interactable,
  NickNameListener,
  GenderListener,
  AgeListener,
  MoodListener
{
  var router: LoginMainRouting? { get set }
  var listener: LoginMainListener? { get set }
  
  var navigationControllerDelegateProxy: NavigationControllerDelegateProxy { get }
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
    
//    print("🔊[DEBUG]: \(navigationControllable)")
//    
//    print(viewControllable)
//    
//    print(viewControllable.uiviewController)
//    
//    print(viewControllable.uiviewController.navigationController)
//    
//    (viewControllable.uiviewController as! UINavigationController).delegate = interactor.navigationControllerDelegateProxy
    
    
  }
  
  func attachNicknameVC() {
    if nicknameRouting != nil { return }
    let router = nicknameBuildable.build(withListener: interactor)
    self.navigationControllable = viewController
    self.navigationControllable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    self.nicknameRouting = router
  }
  
  func detachNicknameVC() {
    guard let router = nicknameRouting else { return }
    self.navigationControllable?.popViewController(animated: true)
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
  
  func detachGenderVC() {
    guard let router = genderRouting else { return }
    self.navigationControllable?.popViewController(animated: true)
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
  
  func detachAgeVC() {
    guard let router = ageRouting else { return }
    self.navigationControllable?.popViewController(animated: true)
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
  
  func detachMoodVC() {
    guard let router = moodRouting else { return }
    self.navigationControllable?.popViewController(animated: true)
    detachChild(router)
    moodRouting = nil
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    print("\(viewController) 팝팝팝팝팝")
  }
  
  func test() {
    print("zzlzlzlz")
  }
}
