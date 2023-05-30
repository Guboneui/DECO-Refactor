//
//  FollowListCell.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import UIKit

import Util
import Entity
import CommonUI

import RxSwift
import PinLayout

class FollowListCell: UICollectionViewCell {
  static let identifier: String = "FollowListCell"
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.makeCornerRadius(radius: 27)
    $0.backgroundColor = .DecoColor.lightBackground
    
  }
  
  private let nameLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.text = "namena"
  }
  
  private let profileLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.gray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 12)
    $0.text = "profile"
  }
  
  private lazy var profileInfoStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, profileLabel]).then {
    $0.axis = .vertical
    $0.spacing = 2
    $0.distribution = .fillEqually
  }
  
  private let followButton: UIButton = UIButton(type: .system).then {
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 8
    $0.backgroundColor = .gray
    $0.setTitle("팔로우", for: .normal)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.contentView.addSubview(profileImageView)
    self.contentView.addSubview(followButton)
    self.contentView.addSubview(profileInfoStackView)

  }
  
  private func setupLayouts() {
    profileImageView.pin
      .vCenter()
      .left(20)
      .size(54)
    
    followButton.pin
      .vCenter()
      .right(20)
      .width(84)
      .height(25)
    
    profileInfoStackView.pin
      .horizontallyBetween(profileImageView, and: followButton, aligned: .center)
      .marginHorizontal(10)
      .height(36)
  }
  
  public func setupCellConfigure(with userInfo: UserDTO, userID: Int) {
    profileImageView.loadImage(imageUrl: userInfo.profileUrl)
    nameLabel.text = userInfo.nickName
    profileLabel.text = userInfo.profileName
    
    if userID == userInfo.userId {
      followButton.isHidden = true
    } else {
      followButton.isHidden = false
      followButton.setTitle(userInfo.followStatus ? "팔로잉" : "팔로우", for: .normal)
      followButton.tintColor = userInfo.followStatus ? .DecoColor.darkGray2 : .DecoColor.whiteColor
      followButton.backgroundColor = userInfo.followStatus ? .DecoColor.whiteColor : .DecoColor.secondaryColor
      followButton.layer.borderColor = userInfo.followStatus ? UIColor.DecoColor.gray1.cgColor : UIColor.clear.cgColor
      followButton.layer.borderWidth = userInfo.followStatus ? 0.5 : 0.0
    }
    
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: 74)
  }
}
