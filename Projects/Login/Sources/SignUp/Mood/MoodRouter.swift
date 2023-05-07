//
//  MoodRouter.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs

protocol MoodInteractable: Interactable {
  var router: MoodRouting? { get set }
  var listener: MoodListener? { get set }
}

protocol MoodViewControllable: ViewControllable {

}

final class MoodRouter: ViewableRouter<MoodInteractable, MoodViewControllable>, MoodRouting {
  
  override init(interactor: MoodInteractable, viewController: MoodViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func signUp() {
    print("🔊[DEBUG]: 메인 화면 이동 로직 만들기")
  }
}
