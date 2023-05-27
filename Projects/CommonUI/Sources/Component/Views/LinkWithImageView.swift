//
//  LinkWithImageView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/27.
//

import UIKit

public class LinkWithImageView: UIView {
  
  private let image: UIImage
  private let title: String
  
  private let imageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.blackColor
  }
  
  private let linkImage: UIImageView = UIImageView().then {
    $0.image = .DecoImage.arrowRight
    $0.contentMode = .scaleAspectFit
  }
  
  public init(image: UIImage, title: String) {
    self.image = image
    self.title = title
    super.init(frame: .zero)
    self.backgroundColor = .DecoColor.whiteColor
    self.imageView.image = image
    self.titleLabel.text = title
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
    self.addSubview(imageView)
    self.addSubview(linkImage)
    self.addSubview(titleLabel)

  }
  
  private func setupLayouts() {
    imageView.pin
      .vCenter()
      .left(20)
      .size(25)
    
    linkImage.pin
      .vCenter()
      .right(18)
      .size(13)
    
    titleLabel.pin
      .horizontallyBetween(imageView, and: linkImage, aligned: .center)
      .marginLeft(6)
      .sizeToFit(.width)
    
    self.pin.height(60)
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 60)
  }
}

