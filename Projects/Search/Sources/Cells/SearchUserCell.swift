//
//  SearchUserCell.swift
//  Search
//
//  Created by 구본의 on 2023/06/13.
//

import UIKit

import Util

import Then
import PinLayout

public class SearchUserCell: UICollectionViewCell {
  
  public static let identifier = "SearchUserCell"

  private let userImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .DecoColor.lightBackground
    $0.makeCornerRadius(radius: 25)
  }
  
  private let userNicknameLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.blackColor
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
  }
  
  private let userProfileNameLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.gray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 12)
  }
  
  private let profileInfoFlexView: UIView = UIView().then {
    $0.backgroundColor = .gray
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    self.userImageView.image = nil
    self.userNicknameLabel.text = nil
    self.userProfileNameLabel.text = nil
  }
  
  private func setupViews() {
    contentView.flex.direction(.row).padding(0, 16, 0, 0).define { flex in
      flex.addItem(userImageView).size(50)
      flex.addItem().direction(.column).justifyContent(.center).padding(0, 12).define { flex in
        flex.addItem(userNicknameLabel)
        flex.addItem(userProfileNameLabel).marginTop(2)
      }.width(UIScreen.main.bounds.width - 66)
    }
  }
  
  private func setupLayouts() {
    contentView.flex.layout(mode: .adjustHeight)
  }
  
  
  public func setupCellConfigure(
    profileImageURL: String,
    userNickname: String,
    userProfileName: String
  ) {
    self.userImageView.loadImageWithThumbnail(
      thumbnail: .DecoImage.thumbnail,
      imageUrl: profileImageURL
    )
    self.userNicknameLabel.text = userNickname
    self.userNicknameLabel.flex.markDirty()
    self.userProfileNameLabel.text = userProfileName
    self.userProfileNameLabel.flex.markDirty()
  }
}
