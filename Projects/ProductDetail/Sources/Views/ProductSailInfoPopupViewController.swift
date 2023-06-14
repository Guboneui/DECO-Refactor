//
//  ProductSailInfoPopupViewController.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import UIKit

import Util

import Then
import RxSwift
import PinLayout
import FlexLayout

class ProductSailInfoPopupViewController: UIViewController {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let bgView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.6)
    $0.alpha = 0.0
  }
  
  private let infoView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadius(radius: 12)
  }
  
  private let sailInfoLabel: UILabel = UILabel().then {
    $0.text = "구매 정보"
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let sailInfoImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.info
  }
  
  private let contentsLabel: UILabel = UILabel().then {
    $0.text = "편의를 위한 정보 제공으로 실시간 가격 및 재고 정보와 상이할 수 있습니다. 정확한 내용은 해당 제품 판매처에서 확인 부탁드립니다."
    $0.lineBreakMode = .byCharWrapping
    $0.numberOfLines = 0
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .regular, size: 12)
  }
  
  private let confirmButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("확인")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
    self.popupAnimation()
  }
  
  private func setupViews() {
    self.view.addSubview(bgView)
    self.view.addSubview(infoView)
    
    infoView.flex.direction(.column)
      .justifyContent(.center)
      .padding(20, 16)
      .define { flex in
        flex.addItem().direction(.row)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(sailInfoLabel)
            flex.addItem(sailInfoImageView).size(24).marginLeft(2)
        }
        flex.addItem(contentsLabel).marginVertical(18)
        flex.addItem(confirmButton)
      }
  }
  
  private func setupLayouts() {
    bgView.pin.all()
    infoView.pin
      .vCenter()
      .horizontally(20)
      .height(200)
    
    infoView.flex.layout(mode: .adjustHeight)
  }
  
  private func setupGestures() {
    self.bgView.tap()
      .bind { [weak self] _ in
        guard let self = self else { return }
        self.hideAnimation()
      }.disposed(by: disposeBag)
    
    self.confirmButton.tap()
      .bind { [weak self] in
        guard let self = self else { return }
        self.hideAnimation()
      }.disposed(by: disposeBag)
  }
  
  private func popupAnimation() {
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
      guard let self = self else { return }
      self.bgView.alpha = 1.0
      self.infoView.alpha = 1.0
    }
  }
  
  private func hideAnimation() {
    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
      guard let self = self else { return }
      self.bgView.alpha = 0.0
      self.infoView.alpha = 0.0
    } completion: { _ in
      self.dismiss(animated: false)
      self.removeFromParent()
    }
  }
}
