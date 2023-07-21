//
//  MainInteractor.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import UIKit

import Home
import Product
import Bookmark
import Profile

import RIBs
import RxSwift
import RxRelay

public enum TabType {
  case Home
  case Product
  case Upload
  case Bookmark
  case Profile
}

public protocol MainRouting: ViewableRouting {

}

protocol MainPresentable: Presentable {
  var listener: MainPresentableListener? { get set }
  func setChildVC(with type: TabType)
}

public protocol MainListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
  
  weak var router: MainRouting?
  weak var listener: MainListener?
  
  private let disposeBag: DisposeBag = DisposeBag()

  lazy var currentTab: BehaviorRelay<TabType> = .init(value: .Home)
  
  override init(presenter: MainPresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    self.setupBindings()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  private func setupBindings() {
    currentTab
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] tab in
        guard let self else { return }
        self.presenter.setChildVC(with: tab)
    }).disposed(by: disposeBag)
  }
}
