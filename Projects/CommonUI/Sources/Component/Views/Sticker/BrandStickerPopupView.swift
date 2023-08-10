//
//  BrandStickerPopupView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/08/11.
//

import UIKit
import Then
import RxSwift
import SnapKit

public class BrandStickerPopupView: UIViewController {
  
  private let brandName: String
  
  public init(brandName: String) {
    self.brandName = brandName
    super.init(nibName: nil, bundle: nil)
  }
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let bgView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.6)
    $0.alpha = 0.0
  }
  
  private let baseView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadius(radius: 16)
    $0.alpha = 0.0
  }
  
  private lazy var brandNameLabel: UILabel = UILabel().then {
    $0.text = brandName
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.textColor = .DecoColor.darkGray2
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .clear
    self.setupViews()
    self.setupLayouts()
    self.setupGestures()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.popupAnimation()
  }
  
  private func setupViews() {
    view.addSubview(bgView)
    view.addSubview(baseView)
    baseView.addSubview(brandNameLabel)
  }
  
  private func setupLayouts() {
    bgView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    baseView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(50)
      make.centerY.equalToSuperview()
    }
    
    brandNameLabel.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(38)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupGestures() {
    self.view.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.hideAnimation()
      }.disposed(by: disposeBag)
  }
  
  private func popupAnimation() {
    self.view.layoutIfNeeded()
    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
      guard let self else { return }
      self.bgView.alpha = 1.0
      self.baseView.alpha = 1.0
    }
  }
  
  private func hideAnimation() {
    UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
      guard let self = self else { return }
      self.bgView.alpha = 0.0
      self.baseView.alpha = 0.0
    } completion: { [weak self] _ in
      guard let self else { return }
      self.dismiss(animated: false)
      self.removeFromParent()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
