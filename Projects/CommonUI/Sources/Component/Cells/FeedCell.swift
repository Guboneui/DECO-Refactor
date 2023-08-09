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
  
  private let disposeBag: DisposeBag = DisposeBag()
  fileprivate var didTapProfileImage: (()->())?
  
  private let userProfileImageView = UIImageView().then {
    $0.backgroundColor = .DecoColor.lightBackground
    $0.layer.cornerRadius = 16
    $0.layer.masksToBounds = true
  }
  
  private let userNameLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  }
  
  private let userDescriptionLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 12)
  }
  
  private lazy var userInfoStackView = UIStackView(arrangedSubviews: [userNameLabel, userDescriptionLabel]).then {
    $0.axis = .vertical
    $0.spacing = 4
  }
  
  private let timeLabel = UILabel().then {
    $0.textColor = .white
    $0.textAlignment = .right
    $0.font = .DecoFont.getFont(with: .Suit, type: .regular, size: 10)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    self.setupGestures()
    
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
  
  private func setupGestures() {
    userProfileImageView.tap()
      .subscribe(onNext: { [weak self] _ in
        self?.didTapProfileImage?()
      }).disposed(by: disposeBag)
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
  private let disposeBag: DisposeBag = DisposeBag()
  fileprivate var didTapLikeButton: (()->())?
  fileprivate var didTapCommentButton: (()->())?
  fileprivate var didTapBookmarkButton: (()->())?
  
  private let likeButton = UIButton(type: .system).then {
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
  
  private let commentButton = UIButton(type: .system).then {
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
  
  private let bookmarkButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.saveThick, for: .normal)
    $0.tintColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupViews()
    self.setupGestures()
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
  
  private func setupGestures() {
    likeButton.tap()
      .subscribe(onNext: { [weak self] in
        self?.didTapLikeButton?()
      }).disposed(by: disposeBag)
    
    commentButton.tap()
      .subscribe(onNext: { [weak self] in
        self?.didTapCommentButton?()
      }).disposed(by: disposeBag)
    
    bookmarkButton.tap()
      .subscribe(onNext: { [weak self] in
        self?.didTapBookmarkButton?()
      }).disposed(by: disposeBag)
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
  public var didTapProfileImage: (()->())?
  public var didTapLikeButton: (()->())?
  public var didTapCommentButton: (()->())?
  public var didTapBookmarkButton: (()->())?
  public var didTapProductSticker: ((Int)->())?
  
  private let feedImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private let topGradientView = UIView()
  private let bottomGradientView = UIView()
  
  private let headerView: FeedCellHeaderView = FeedCellHeaderView()
  private let footerView: FeedCellFooterView = FeedCellFooterView()
  
  private var brandStickerViews: [FeedStickerView] = []
  private var productStickerViews: [FeedStickerView] = []
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupLayouts()
    self.setupGestures()
    self.makeGradientLayer()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    brandStickerViews.forEach{ $0.removeFromSuperview() }
    productStickerViews.forEach{ $0.removeFromSuperview() }
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
      make.height.equalTo(38)
    }
  }
  
  private func setupGestures() {
    
    // MARK: HeaderView Gesture
    headerView.didTapProfileImage = { [weak self] in
      self?.didTapProfileImage?()
    }
    
    // MARK: FooterView Gesture
    footerView.didTapLikeButton = { [weak self] in
      self?.didTapLikeButton?()
    }
    
    footerView.didTapCommentButton = { [weak self] in
      self?.didTapCommentButton?()
    }
    
    footerView.didTapBookmarkButton = { [weak self] in
      self?.didTapBookmarkButton?()
    }
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
    
    makeBrandSticker(
      mainWidth: CGFloat(postingData.width ?? 0),
      mainHeight: CGFloat(postingData.height ?? 0),
      brands: postingData.postingBrandObjectViews
    )
    
    makeProductSticker(
      mainWidth: CGFloat(postingData.width ?? 0),
      mainHeight: CGFloat(postingData.height ?? 0),
      products: postingData.postingProductObjectViews
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

// MARK: - Brand & Product Sticker

extension FeedCell {
  /// 브랜드 스티커를 만들어 줍니다.
  private func makeBrandSticker(
    mainWidth: CGFloat,
    mainHeight: CGFloat,
    brands: [PostingBrandObjectView]
  ) {
    let containerWidth = feedImageView.frame.width
    let containerHeight = feedImageView.frame.height
    
    for brandObject in brands {
      let x = abs((brandObject.translationX ?? 0.0) * containerWidth / mainWidth)
      let y = abs((brandObject.translationY ?? 0.0) * containerHeight / mainHeight)
      
      let sticker = FeedStickerView(
        with: brandObject.postingBrand?.name ?? "",
        type: .brand,
        direction: brandObject.direction ?? "",
        isKnown: brandObject.known ?? false
      )
      
      brandStickerViews.append(sticker)
      
      self.contentView.addSubview(sticker)
      sticker.layoutIfNeeded()
      
      sticker.pin
        .topLeft()
        .marginLeft(x)
        .marginTop(y)
    }
  }
  
  /// 상품 스티커를 만들어 줍니다.
  private func makeProductSticker(
    mainWidth: CGFloat,
    mainHeight: CGFloat,
    products: [PostingProductObjectView]
  ) {
    let containerWidth = feedImageView.frame.width
    let containerHeight = feedImageView.frame.height
    
    for productObject in products {
      let x = abs((productObject.translationX ?? 0.0) * containerWidth / mainWidth)
      let y = abs((productObject.translationY ?? 0.0) * containerHeight / mainHeight)
      
      let sticker = FeedStickerView(
        with: productObject.postingProduct?.name ?? "",
        type: .brand,
        direction: productObject.direction ?? "",
        isKnown: true
      )
      sticker.tag = productObject.postingProduct?.id ?? 0
      sticker.tap()
        .bind { [weak self] _ in
          guard let self else { return }
          self.didTapProductSticker?(sticker.tag)
        }.disposed(by: disposeBag)
      
      productStickerViews.append(sticker)
      
      self.contentView.addSubview(sticker)
      sticker.layoutIfNeeded()
      
      sticker.pin
        .topLeft()
        .marginLeft(x)
        .marginTop(y)
    }
  }
}
