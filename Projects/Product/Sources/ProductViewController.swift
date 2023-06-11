//
//  ProductViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift
import UIKit
import Then
import PinLayout
import CommonUI
import Util
import Networking

public enum ProductTabType {
  case Product
  case Brand
}

protocol ProductPresentableListener: AnyObject {
  func addChildVCLayout(with type: ProductTabType)
  func pushSearchVC()
}

final public class ProductViewController: UIViewController, ProductPresentable, ProductViewControllable {
  
  weak var listener: ProductPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let searchView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.lightGray1
    $0.makeCornerRadius(radius: 10)
  }
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.search
    $0.tintColor = .DecoColor.gray2
  }
  
  private let searchLabel: UILabel = UILabel().then {
    $0.text = "브랜드 및 상품 검색하기"
    $0.textColor = .DecoColor.gray1
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
  }
  
  private let productButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("상품")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.tintColor = .DecoColor.darkGray2
    $0.sizeToFit()
  }
  
  private let brandButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("브랜드")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.tintColor = .DecoColor.lightGray2
    $0.sizeToFit()
  }
  
  private let parentVCContainerView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(searchView)
    self.view.addSubview(productButton)
    self.view.addSubview(brandButton)
    self.view.addSubview(parentVCContainerView)
    
    searchView.flex.direction(.row).alignItems(.center).define { flex in
      flex.addItem(searchImageView).marginLeft(14).size(20)
      flex.addItem(searchLabel).marginLeft(20)
    }
  }
  
  private func setupLayouts() {
    searchView.pin
      .top(view.pin.safeArea)
      .horizontally()
      .marginHorizontal(22)
      .marginTop(10)
      .height(32)
    
    searchView.flex.layout()
    
    productButton.pin
      .below(of: searchView)
      .left(30)
      .marginTop(24)
      .height(20)
    
    brandButton.pin
      .after(of: productButton, aligned: .center)
      .marginLeft(32)
      .height(20)
    
    parentVCContainerView.pin
      .below(of: [productButton, brandButton])
      .horizontally()
      .bottom()
      .marginTop(24)
    
  }
  
  private func setupGestures() {
    productButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.addChildVCLayout(with: .Product)
        self.categoryButtonDidSelected(with: .Product)
      }.disposed(by: disposeBag)
    
    brandButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.addChildVCLayout(with: .Brand)
        self.categoryButtonDidSelected(with: .Brand)
      }.disposed(by: disposeBag)
    
    searchView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.pushSearchVC()
      }.disposed(by: disposeBag)
  }
  
  func setChildVCLayout(childVC: ViewControllable) {
    if let child = self.children.first,
       childVC.uiviewController != child {
      self.removeChildVCLayout()
      self.addChildVCLayout(with: childVC)
    } else {
      self.addChildVCLayout(with: childVC)
    }
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
  
  private func categoryButtonDidSelected(with type: ProductTabType) {
    switch type {
    case .Product:
      self.productButton.tintColor = .DecoColor.darkGray2
      self.brandButton.tintColor = .DecoColor.lightGray2
    case .Brand:
      self.productButton.tintColor = .DecoColor.lightGray2
      self.brandButton.tintColor = .DecoColor.darkGray2
    }
  }
}
