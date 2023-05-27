//
//  ProfileView.swift
//  Profile
//
//  Created by 구본의 on 2023/05/24.
//

import UIKit

import Util
import Entity
import CommonUI

import Then
import PinLayout

class ProfileView: UIView {
  
  private let backgroundImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFill
  }
  
  private let backgroundGrayView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.2)
  }
  
  private let profileImageShadowView: UIView = UIView().then {
    $0.layer.shadowColor = UIColor.DecoColor.blackColor.withAlphaComponent(0.25).cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    $0.layer.shadowOpacity = 1.0
    $0.layer.shadowRadius = 4
    $0.layer.cornerRadius = 45
  }
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.makeCornerRadius(radius: 45)
  }
  
  private let profileTitleLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 20)
    $0.textColor = .white
  }
  
  private let profileNicknameLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textColor = .white
  }
  
  private let profileDescriptionLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .white
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(backgroundImageView)
    self.addSubview(backgroundGrayView)
    self.addSubview(profileImageShadowView)
    self.profileImageShadowView.addSubview(profileImageView)
    self.addSubview(profileTitleLabel)
    self.addSubview(profileNicknameLabel)
    self.addSubview(profileDescriptionLabel)
  }
  
  private func setupLayouts() {
    backgroundImageView.pin.all()
    backgroundGrayView.pin.all()
    
    profileImageShadowView.pin
      .center()
      .size(90)
      .marginBottom(12)
    
    profileImageView.pin
      .all()
    
    profileTitleLabel.pin
      .above(of: profileImageView)
      .marginBottom(24)
      .horizontally()
      .sizeToFit(.width)
    
    profileNicknameLabel.pin
      .below(of: profileImageView)
      .marginTop(8)
      .horizontally()
      .sizeToFit(.width)
    
    profileDescriptionLabel.pin
      .below(of: profileNicknameLabel)
      .bottom()
      .horizontally(40)
      .marginTop(32)
      .sizeToFit(.width)
    
    
    self.pin
      .size(UIScreen.main.bounds.width)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: size.width)
  }
  
  public func setProfile(with profileInfo: ProfileDTO) {    
    self.backgroundImageView.loadImage(imageUrl: profileInfo.backgroundUrl)
    self.profileImageView.loadImage(imageUrl: profileInfo.profileUrl)
    self.profileTitleLabel.text = profileInfo.profileName
    self.profileNicknameLabel.text = profileInfo.nickname
    self.profileDescriptionLabel.text = profileInfo.profileDescription
  }
}

