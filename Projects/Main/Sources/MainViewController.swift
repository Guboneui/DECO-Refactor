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

protocol MainPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class MainViewController: UIViewController, MainPresentable, MainViewControllable {

  weak var listener: MainPresentableListener?

  private let disposeBag: DisposeBag = DisposeBag()

  private let tabbarContainer: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
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

    tabbarContainer.flex.direction(.row).define { flex in
      flex.addItem(homeTab).grow(1)
      flex.addItem(productTab).grow(1)
      flex.addItem(uploadTab).grow(1)
      flex.addItem(bookmarkTab).grow(1)
      flex.addItem(profileTab).grow(1)
    }

    self.view.addSubview(tabbarContainer)

  }

  private func setupLayouts() {
    tabbarContainer.pin
      .horizontally()
      .bottom(view.pin.safeArea)
      .height(56)

    tabbarContainer.flex.layout()
  }

  private func setupGestures() {
    homeTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("HOME")
        
      }.disposed(by: disposeBag)
    
    productTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("PRODUCT")
        
      }.disposed(by: disposeBag)
    
    uploadTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("UPLOAD")
        
      }.disposed(by: disposeBag)
    
    bookmarkTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("BOOKMARK")
        
      }.disposed(by: disposeBag)
    
    profileTab.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("PROFILE")
        
      }.disposed(by: disposeBag)

  }
}
