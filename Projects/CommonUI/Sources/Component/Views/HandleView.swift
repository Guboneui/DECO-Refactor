//
//  HandleView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/07/25.
//

import UIKit
import PinLayout

public class HandleView: UIView {
  
  private let handleView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.gray1
    $0.makeCornerRadius(radius: 1.5)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .DecoColor.whiteColor
    self.addSubview(handleView)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }

  private func setupLayouts() {
    handleView.pin
      .top(16)
      .bottom()
      .hCenter()
      .height(3)
      .width(32)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
