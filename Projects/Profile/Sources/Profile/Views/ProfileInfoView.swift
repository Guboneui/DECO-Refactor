//
//  ProfileInfoView.swift
//  Profile
//
//  Created by 구본의 on 2023/05/24.
//

import UIKit

import User
import Entity
import CommonUI

import Then
import PinLayout
import RxSwift
import RxGesture

enum ProfileInfoType: String {
  case FOLLOWER = "팔로워"
  case FOLLOWING = "팔로잉"
  case POSTING = "게시글"
}

class ProfileInfoView: UIView {
  
  var didTapFollowerView: (()->())?
  var didTapFollowingView: (()->())?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
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
    self.backgroundColor = .white
    self.setupViews()
    self.setupGestures()
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
  
  private func setupGestures() {
    self.followerInfoView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.didTapFollowerView?()
      }.disposed(by: disposeBag)
    
    self.followingInfoView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.didTapFollowingView?()
      }.disposed(by: disposeBag)
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: guideLineView.frame.maxY)
  }
  
  public func setProfileInfo(with profileInfo: UserManagerModel) {
    self.followerInfoView.setupText(title: "\(profileInfo.followCount)명", info: ProfileInfoType.FOLLOWER.rawValue)
    self.followingInfoView.setupText(title: "\(profileInfo.followingCount)명", info: ProfileInfoType.FOLLOWING.rawValue)
    self.postingInfoView.setupText(title: "\(profileInfo.boardCount)건", info: ProfileInfoType.POSTING.rawValue)
  }
}
