//
//  FeedCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/07/20.
//

import UIKit
import Entity
import Util
import SnapKit
import Then
import RxSwift

private class FeedCellHeaderView: UIView {
  private let userProfileImageView = UIImageView().then {
    $0.backgroundColor = .DecoColor.lightBackground
    $0.layer.cornerRadius = 16
    $0.layer.masksToBounds = true
  }
  
  private let userNameLabel = UILabel().then {
    $0.textColor = .white
    $0.text = "이름"
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  }
  
  private let userDescriptionLabel = UILabel().then {
    $0.textColor = .white
    $0.text = "디스크립션"
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 12)
  }
  
  private lazy var userInfoStackView = UIStackView(arrangedSubviews: [userNameLabel, userDescriptionLabel]).then {
    $0.axis = .vertical
    $0.spacing = 4
  }
  
  private let timeLabel = UILabel().then {
    $0.textColor = .white
    $0.textAlignment = .right
    $0.text = "시간"
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 10)
  }

  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    
  }
  

  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.addSubview(userProfileImageView)
    self.addSubview(userInfoStackView)
    self.addSubview(timeLabel)
  }
  
  private func setupLayouts() {
    
    userProfileImageView.snp.makeConstraints { make in
      make.size.equalTo(32)
      make.leading.equalToSuperview().offset(20)
      make.verticalEdges.equalToSuperview().inset(3)
    }
    
    timeLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(3)
      make.trailing.equalToSuperview().offset(-20)
      make.width.equalTo(75)
    }
    
    userInfoStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(userProfileImageView.snp.trailing).offset(12)
      make.trailing.equalTo(timeLabel.snp.leading).offset(-12)
    }
  }
  
  fileprivate func setHeaderViewData(
    profileURL: String,
    userName: String,
    profileName: String,
    createdAt: Int
  ) {
    userProfileImageView.loadLowQualityImage(imageUrl: profileURL)
    userNameLabel.text = userName
    userDescriptionLabel.text = profileName
    let date = Date().getTimeInterver(serverTime: createdAt)
    timeLabel.text = date == "0초 후" ? "방금" : date
    
    self.setupLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private class FeedCellFooterView: UIView {
  let likeButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.like, for: .normal)
    $0.tintColor = .white
  }
  
  private let likeLabel: UILabel = UILabel().then {
    $0.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    $0.textColor = .white
    $0.makeCornerRadius(radius: 8.5)
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 8)
    $0.textAlignment = .center
  }
  
  let commentButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.message, for: .normal)
    $0.tintColor = .white
  }
  
  private let commentLabel: UILabel = UILabel().then {
    $0.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    $0.textColor = .white
    $0.makeCornerRadius(radius: 8.5)
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 8)
    $0.textAlignment = .center
  }
  
  
  let bookmarkButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.saveThick, for: .normal)
    $0.tintColor = .white
  }
  private let disposeBag: DisposeBag = DisposeBag()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.addSubview(likeButton)
    self.addSubview(likeLabel)
    self.addSubview(commentButton)
    self.addSubview(commentLabel)
    self.addSubview(bookmarkButton)
  }
  
  private func setupLayouts() {
    likeButton.snp.makeConstraints { make in
      make.size.equalTo(38)
      make.bottom.equalToSuperview().offset(-8)
      make.leading.equalToSuperview().offset(24)
    }
    
    likeLabel.snp.makeConstraints { make in
      make.top.equalTo(likeButton.snp.top)
      make.trailing.equalTo(likeButton.snp.trailing).offset(2)
      make.size.equalTo(17)
    }
    
    commentButton.snp.makeConstraints { make in
      make.size.equalTo(38)
      make.bottom.equalToSuperview().offset(-8)
      make.centerX.equalToSuperview()
    }
    
    commentLabel.snp.makeConstraints { make in
      make.top.equalTo(commentButton.snp.top)
      make.trailing.equalTo(commentButton.snp.trailing)
      make.size.equalTo(17)
    }
    
    
    bookmarkButton.snp.makeConstraints { make in
      make.size.equalTo(38)
      make.bottom.equalToSuperview().offset(-8)
      make.trailing.equalToSuperview().offset(-24)
    }
  }
  
  fileprivate func setFooterViewData(
    likeCount: Int,
    isLike: Bool,
    commentCount: Int,
    isBookmark: Bool
  ) {
    // 좋아요
    if likeCount == 0 {
      likeLabel.isHidden = true
    } else {
      likeLabel.isHidden = false
      likeLabel.text = "\(likeCount)"
    }
    
    likeButton.setImage(isLike ? .DecoImage.likeFull : .DecoImage.like)
    
    // 댓글
    if commentCount == 0 {
      commentLabel.isHidden = true
    } else {
      commentLabel.isHidden = false
      commentLabel.text = "\(commentCount)"
    }
    
    // 저장
    bookmarkButton.setImage(isBookmark ? .DecoImage.saveFull : .DecoImage.saveThick)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public class FeedCell: UICollectionViewCell {
  
  public static let identifier = "FeedCell"
  private let disposeBag = DisposeBag()
  
  
  private let feedImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private let topGradientView = UIView()
  private let bottomGradientView = UIView()
  
  private let headerView: FeedCellHeaderView = FeedCellHeaderView()
  private let footerView: FeedCellFooterView = FeedCellFooterView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupLayouts()
    self.makeGradientLayer()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  
  private func setupViews() {
    
  }
  
  private func setupLayouts() {
    self.contentView.addSubview(feedImageView)
    feedImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.contentView.addSubview(topGradientView)
    self.contentView.addSubview(bottomGradientView)
    topGradientView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(100)
    }
    
    bottomGradientView.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
      make.width.equalTo(UIScreen.main.bounds.width)
      make.height.equalTo(100)
    }
    
    self.contentView.addSubview(headerView)
    self.contentView.addSubview(footerView)

    headerView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    
    footerView.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setupGestures() {
    footerView.likeButton.tap()
      .bind { [weak self] in
        print("TAP In Parent")
        self?.didTapLikeButton?()
      }.disposed(by: disposeBag)
    
    footerView.likeButton.tap()
      .bind { [weak self] in
        self?.didTapCommentButton?()
      }.disposed(by: disposeBag)
    
    footerView.bookmarkButton.tap()
      .bind { [weak self] in
        self?.didTapBookmarkButton?()
      }.disposed(by: disposeBag)
  }
  
  public func setFeedCellConfigure(with postingData: PostingDTO) {
    feedImageView.loadImage(imageUrl: postingData.imageUrl ?? "")

    headerView.setHeaderViewData(
      profileURL: postingData.profileUrl ?? "",
      userName: postingData.userName ?? "",
      profileName: postingData.profileName ?? "",
      createdAt: postingData.createdAt ?? 0
    )
    
    footerView.setFooterViewData(
      likeCount: postingData.likeCount ?? 0,
      isLike: postingData.like ?? false,
      commentCount: postingData.replyCount ?? 0,
      isBookmark: postingData.scrap ?? false
    )
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension FeedCell {
  private func makeGradientLayer() {
    let gradientColor: CGColor = UIColor.black.withAlphaComponent(0.2).cgColor
    
    self.contentView.layoutIfNeeded()
    self.contentView.setNeedsLayout()
    self.contentView.backgroundColor = .DecoColor.darkGray2
    
    
    var topGradientLayer: CAGradientLayer!
    topGradientLayer = CAGradientLayer()
    topGradientLayer.frame = self.topGradientView.bounds
    topGradientLayer.colors = [gradientColor, UIColor.clear.cgColor]
    self.topGradientView.layer.insertSublayer(topGradientLayer, at: 0)
    
    var bottomGradientLayer: CAGradientLayer!
    bottomGradientLayer = CAGradientLayer()
    bottomGradientLayer.frame = self.bottomGradientView.bounds
    bottomGradientLayer.colors = [UIColor.clear.cgColor, gradientColor]
    self.bottomGradientView.layer.insertSublayer(bottomGradientLayer, at: 0)
  }
}

