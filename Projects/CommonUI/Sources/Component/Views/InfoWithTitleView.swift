//
//  InfoWithTitleView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/24.
//

import UIKit

public class InfowithTitleVlew: UIView {
  
  private let titleLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    $0.textColor = .DecoColor.darkGray1
    $0.textAlignment = .center
  }
  
  private let infoLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray1
    $0.textAlignment = .center
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(titleLabel)
    self.addSubview(infoLabel)
  }
  
  private func setupLayouts() {
    titleLabel.pin
      .top(7)
      .horizontally()
      .sizeToFit(.width)
    
    infoLabel.pin
      .below(of: titleLabel)
      .horizontally()
      .marginTop(4)
      .bottom(12)
      .sizeToFit(.width)
  }
  
  public func setupText(title: String, info: String) {
    self.titleLabel.text = title
    self.infoLabel.text = info
    self.setupLayouts()
  }
}
