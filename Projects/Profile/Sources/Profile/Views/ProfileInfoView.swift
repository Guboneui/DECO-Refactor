//
//  ProfileInfoView.swift
//  Profile
//
//  Created by 구본의 on 2023/05/24.
//

import UIKit

import CommonUI

import Then
import PinLayout

class ProfileInfoView: UIView {
  
  var didTapFollowerView: (()->())?
  var didTapFollowingView: (()->())?
  var didTapPostingView: (()->())?
  
  private let segmentView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.darkGray1
  }
  
  private let followerInfoView: InfowithTitleVlew = InfowithTitleVlew()
  private let followingInfoView: InfowithTitleVlew = InfowithTitleVlew()
  private let postingInfoView: InfowithTitleVlew = InfowithTitleVlew()
  
  private lazy var profileStackView: UIStackView = UIStackView(arrangedSubviews: [followerInfoView, followingInfoView, postingInfoView]).then {
    $0.axis = .horizontal
    $0.spacing = 1
    $0.distribution = .fillEqually
  }
  
  private let guideLineView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.lightGray1
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    self.backgroundColor = .white
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(segmentView)
    self.addSubview(profileStackView)
    self.addSubview(guideLineView)
  }
  
  private func setupLayouts() {

    segmentView.pin
      .vCenter()
      .horizontally()
      .height(11)
  
    profileStackView.pin
      .all()
      .height(52)
    
    guideLineView.pin
      .below(of: profileStackView)
      .horizontally()
      .height(0.25)
    
    
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: guideLineView.frame.maxY)
  }
}
