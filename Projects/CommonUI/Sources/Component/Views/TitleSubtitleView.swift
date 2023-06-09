//
//  TitleSubtitleView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/04/25.
//

import UIKit
import PinLayout
import FlexLayout
import Then

public class TitleSubtitleView: UIView {
  
  private let title: String
  private let subTitle: String
  
  private let titleLabel: UILabel = UILabel().then {
    $0.font = CommonUIFontFamily.NotoSansKR.medium.font(size: 18)
    $0.textColor = .DecoColor.darkGray2
    $0.numberOfLines = 0
    $0.sizeToFit()
  }
  
  private let subTitleLabel: UILabel = UILabel().then {
    $0.font = CommonUIFontFamily.NotoSansKR.medium.font(size: 12)
    $0.textColor = .DecoColor.lightGray2
    $0.sizeToFit()
  }
  
  public init(title: String = "", subTitle: String = "") {
    self.title = title
    self.subTitle = subTitle
    super.init(frame: .zero)
    self.setupViews()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setupTitleSubtitle(title: String, subTitle: String) {
    titleLabel.text = title
    subTitleLabel.text = subTitle
  }
  
  private func setupViews() {
    titleLabel.text = title
    subTitleLabel.text = subTitle
    
    self.addSubview(titleLabel)
    self.addSubview(subTitleLabel)
  }
  
  private func setupLayouts() {
    self.pin.horizontally()
    self.pin.wrapContent(.vertically)
    
    titleLabel.pin
      .top()
      .horizontally()
      .marginLeft(38)
      .sizeToFit()
      
      
    subTitleLabel.pin
      .below(of: titleLabel)
      .bottom()
      .horizontally()
      .marginTop(12)
      .marginLeft(38)
      .sizeToFit()
  }
}
