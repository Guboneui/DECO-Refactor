//
//  BookmarkImageCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/29.
//

import UIKit

import Util

import Then
import PinLayout

public class BookmarkImageCell: UICollectionViewCell {
  
  public static let identifier = "BookmarkImageCell"
  
  public var didTapBookmarkButton: (()->())?
  
  private let mainImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .DecoColor.lightBackground
    $0.layer.masksToBounds = true
  }
  
  private let bookmarkButton: UIButton = UIButton(type: .system)
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    self.setupGestures()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.contentView.addSubview(mainImageView)
    self.contentView.addSubview(bookmarkButton)
  }
  
  private func setupLayouts() {
    self.mainImageView.pin.all()
    bookmarkButton.pin
      .bottomRight(8)
      .size(25)
    self.contentView.pin.wrapContent()
  }
  
  private func setupGestures() {
    bookmarkButton.addTarget(self, action: #selector(tapBookmarkButton), for: .touchUpInside)
  }
  
  @objc private func tapBookmarkButton() {
    self.didTapBookmarkButton?()
  }
  
  public func setupCellConfigure(
    imageURL: String,
    isBookmarked: Bool
  ) {
    self.mainImageView.loadImage(imageUrl: imageURL)
    self.bookmarkButton.setImage(isBookmarked ? .DecoImage.saveFullWhite : .DecoImage.saveThick, for: .normal)
    self.bookmarkButton.tintColor = isBookmarked ? .DecoColor.secondaryColor : .DecoColor.gray4

  }
}
