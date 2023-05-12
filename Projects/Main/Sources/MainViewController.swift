//
//  MainViewController.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs
import RxSwift
import UIKit
import Util
import CommonUI
import Home

protocol MainPresentableListener: AnyObject {
  func showNewChildVC(with type: TabType)
  func hidePrevChildVC()
  func removeChildVCRib()
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {
  
  weak var listener: MainPresentableListener?

  private let disposeBag: DisposeBag = DisposeBag()

  private let tabbarContainer: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }

  private let parentVCContainerView: UIView = UIView().then {
    $0.backgroundColor = .blue
  }
  
  private let homeTab: TabbarView = TabbarView(image: .DecoImage.home, title: "홈")
  private let productTab: TabbarView = TabbarView(image: .DecoImage.findlist, title: "상품")
  private let uploadTab: TabbarView = TabbarView(image: .DecoImage.upload, title: "업로드")
  private let bookmarkTab: TabbarView = TabbarView(image: .DecoImage.save, title: "저장목록")
  private let profileTab: TabbarView = TabbarView(image: .DecoImage.profile, title: "프로필")

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }

  private func setupViews() {

    self.view.addSubview(tabbarContainer)
    self.view.addSubview(parentVCContainerView)
    
    tabbarContainer.flex.direction(.row).define { flex in
      flex.addItem(homeTab).grow(1)
      flex.addItem(productTab).grow(1)
      flex.addItem(uploadTab).grow(1)
      flex.addItem(bookmarkTab).grow(1)
      flex.addItem(profileTab).grow(1)
    }
  }

  private func setupLayouts() {
    tabbarContainer.pin
      .horizontally()
      .bottom(view.pin.safeArea)
      .height(56)

    tabbarContainer.flex.layout()
    
    parentVCContainerView.pin
      .top(view.pin.safeArea.top)
      .above(of: tabbarContainer)
      .horizontally()
  }

  private func setupGestures() {
    homeTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        if let currentChildVC = self.children.first,
           currentChildVC != HomeViewController() {
          self.removeLayoutPrevChildVC()
          self.setLayoutNewChildVC(with: .Home)
          self.listener?.showNewChildVC(with: .Home)
        }
      }.disposed(by: disposeBag)
    
    productTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.removeLayoutPrevChildVC()
        self.setLayoutNewChildVC(with: .Product)
        self.listener?.showNewChildVC(with: .Product)
      }.disposed(by: disposeBag)
    
    
    uploadTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("UPLOAD")
        
      }.disposed(by: disposeBag)
    
    bookmarkTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.removeLayoutPrevChildVC()
        self.setLayoutNewChildVC(with: .Bookmark)
        self.listener?.showNewChildVC(with: .Bookmark)
      }.disposed(by: disposeBag)
    
    profileTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.removeLayoutPrevChildVC()
        self.setLayoutNewChildVC(with: .Profile)
        self.listener?.showNewChildVC(with: .Profile)
      }.disposed(by: disposeBag)

  }
  
  func startWithHomeVC(vc: ViewControllable) {
    self.addChild(vc.uiviewController)
    parentVCContainerView.addSubview(vc.uiviewController.view)
    vc.uiviewController.view.frame = self.parentVCContainerView.bounds // childVC Frame 설정
    vc.uiviewController.view.pin.pinEdges()
    vc.uiviewController.didMove(toParent: self)
  }
  
  
  private func setLayoutNewChildVC(with type: TabType) {
    listener?.showNewChildVC(with: type)
  }
  
  private func removeLayoutPrevChildVC() {
    self.children.forEach { prevChildVC in
      prevChildVC.willMove(toParent: nil)
      prevChildVC.view.removeFromSuperview()
      prevChildVC.removeFromParent()
    }
    
    self.listener?.removeChildVCRib()
  }
}
