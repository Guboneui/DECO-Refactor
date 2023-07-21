//
//  MainViewController.swift
//  Main
//
//  Created by 구본의 on 2023/05/09.
//

import UIKit

import Util
import CommonUI

import Home

import RIBs
import RxSwift
import RxRelay

protocol MainPresentableListener: AnyObject {
  var currentTab: BehaviorRelay<TabType> { get }
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {

  weak var listener: MainPresentableListener?
  var tabbarViewControllers: [TabType : ViewControllable] = [:]
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let tabbarContainer: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let parentVCContainerView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let homeTab: TabbarView = TabbarView(image: .DecoImage.selectedHomeTab, title: "홈", isSelected: true)
  private let productTab: TabbarView = TabbarView(image: .DecoImage.defaultProductTab, title: "상품", isSelected: false)
  private let uploadTab: TabbarView = TabbarView(image: .DecoImage.defaultUploadTab, title: "업로드", isSelected: false)
  private let bookmarkTab: TabbarView = TabbarView(image: .DecoImage.defaultBookmarkTab, title: "저장목록", isSelected: false)
  private let profileTab: TabbarView = TabbarView(image: .DecoImage.defaultProfileTab, title: "프로필", isSelected: false)
  
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
      .top()
      .above(of: tabbarContainer)
      .horizontally()
  }
  
  private func setupGestures() {
    homeTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.currentTab.accept(.Home)
      }.disposed(by: disposeBag)
    
    productTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.currentTab.accept(.Product)
      }.disposed(by: disposeBag)
    
    uploadTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("🔊[DEBUG]: TODO UPLOAD")
      }.disposed(by: disposeBag)
    
    bookmarkTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.currentTab.accept(.Bookmark)
      }.disposed(by: disposeBag)
    
    profileTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.currentTab.accept(.Profile)
      }.disposed(by: disposeBag)
    
  }
  
  private func addChildVCLayout(with childVC: ViewControllable) {
    self.addChild(childVC.uiviewController)
    self.parentVCContainerView.addSubview(childVC.uiviewController.view)
    childVC.uiviewController.view.frame = self.parentVCContainerView.bounds
    childVC.uiviewController.view.pin.pinEdges()
    childVC.uiviewController.didMove(toParent: self)
  }
  
  private func removeChildVCLayout() {
    self.children.forEach { childVC in
      childVC.willMove(toParent: nil)
      childVC.removeFromParent()
      childVC.view.removeFromSuperview()
    }
  }
  
  private func setTabbarImage(with tab: TabType) {
    homeTab.changeTabbarConfigure(
      image: tab == .Home ? .DecoImage.selectedHomeTab : .DecoImage.defaultHomeTab,
      isSelected: tab == .Home
    )
    
    productTab.changeTabbarConfigure(
      image: tab == .Product ? .DecoImage.selectedProductTab : .DecoImage.defaultProductTab,
      isSelected: tab == .Product
    )
    
    bookmarkTab.changeTabbarConfigure(
      image: tab == .Bookmark ? .DecoImage.selectedBookmarkTab : .DecoImage.defaultBookmarkTab,
      isSelected: tab == .Bookmark
    )
    
    profileTab.changeTabbarConfigure(
      image: tab == .Profile ? .DecoImage.selectedProfileTab : .DecoImage.defaultProfileTab,
      isSelected: tab == .Profile
    )
  }
  
  // MARK: - MainPresentableListener
  func setChildVC(with type: TabType) {
    guard let viewController = tabbarViewControllers[type] else { return }
    self.removeChildVCLayout()
    self.addChildVCLayout(with: viewController)
    self.setTabbarImage(with: type)
  }
}

  }
}
