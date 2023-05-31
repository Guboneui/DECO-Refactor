//
//  MainInteractor.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs
import RxSwift
import Home
import Product
import Bookmark
import Profile
import Foundation
import UIKit

public enum TabType {
  case Home
  case Product
  case Upload
  case Bookmark
  case Profile
}

public protocol MainRouting: ViewableRouting {
  func attachChildVCRib(with type: TabType)
  func detachChildVCRib()
}

protocol MainPresentable: Presentable {
  var listener: MainPresentableListener? { get set }
}

public protocol MainListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
  
  weak var router: MainRouting?
  weak var listener: MainListener?
  
  override init(presenter: MainPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func addChildVCLayout(with type: TabType) {
    router?.attachChildVCRib(with: type)
  }
  
  func removeChildVCLayout() {
    router?.detachChildVCRib()
  }
}
