//
//  EditFilterButtonView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/04.
//

import UIKit
import RxSwift

public class EditFilterButtonView: UIView {
  
  public var didTapResetButton: (()->())?
  public var didTapSelectButton: (()->())?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let resetButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.againDarkgrey)
    $0.backgroundColor = .DecoColor.lightGray1
    $0.tintColor = .DecoColor.darkGray2
    $0.makeCornerRadius(radius: 8)
    $0.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
  }
  
  private let selectButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("필터 편집", for: .normal)
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.tintColor = .DecoColor.darkGray2
    $0.backgroundColor = .DecoColor.primaryColor
    $0.makeCornerRadius(radius: 8)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(resetButton)
    self.addSubview(selectButton)
  }
  
  private func setupLayouts() {
    resetButton.pin
      .vertically()
      .left(28)
      .size(46)
    
    selectButton.pin
      .vertically()
      .left(to: resetButton.edge.right)
      .right(28)
      .height(46)
      .marginLeft(12)
    
    self.pin.height(46)
  }
  
  private func setupGestures() {
    resetButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        
        self.didTapResetButton?()
      }.disposed(by: disposeBag)
    
    selectButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.didTapSelectButton?()
      }.disposed(by: disposeBag)
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 46)
  }
}


