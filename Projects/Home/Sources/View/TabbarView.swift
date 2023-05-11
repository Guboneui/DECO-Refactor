//
//  TabbarView.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import UIKit
import CommonUI
import Then
import PinLayout

class TabbarView: TouchAnimationView {
  private let image: UIImage
  private let title: String
  
  private let tabbarImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .DecoColor.gray4
  }
  
  private let tabbarTitleLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.darkGray1
    $0.textAlignment = .center
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 10)
  }
  
  init(image: UIImage, title: String) {
    self.image = image
    self.title = title
    super.init(frame: .zero)
    self.tabbarImageView.image = image
    self.tabbarTitleLabel.text = title
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayouts() {
    self.flex.direction(.column).alignItems(.center).padding(4).grow(1).define { flex in
      flex.addItem(tabbarImageView).size(28)
      flex.addItem(tabbarTitleLabel).marginTop(6)
    }
  }
}
