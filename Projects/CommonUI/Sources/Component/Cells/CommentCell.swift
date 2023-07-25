//
//  CommentCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/07/26.
//

import UIKit
import SnapKit
import Then

public enum CommentType {
  case Parent
  case Child
}

public class CommentCell: UICollectionViewCell {
  
  public static let identifier: String = "CommentCell"
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.makeCornerRadius(radius: 17)
    $0.backgroundColor = .DecoColor.lightBackground
  }
  
  private let commentLabel: UILabel = UILabel().then {
    $0.textColor = .DecoColor.darkGray2
    $0.lineBreakMode = .byCharWrapping
    $0.numberOfLines = 0
  }
  
  private let timeLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 10)
    $0.textColor = .DecoColor.gray1
  }
  
  private let addCommentButton: UILabel = UILabel().then {
    $0.text = "답글 달기"
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 10)
    $0.textColor = .DecoColor.gray1
    $0.sizeToFit()
  }
  
  private lazy var commentInfoStackView: UIStackView = UIStackView(arrangedSubviews: [timeLabel, addCommentButton]).then {
    $0.axis = .horizontal
    $0.spacing = 12
  }
  
  private let showChildCommentButton: UILabel = UILabel().then {
    $0.textColor = .DecoColor.gray2
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 10)
    $0.sizeToFit()
  }
  
  private lazy var commentStackView: UIStackView = UIStackView(arrangedSubviews: [commentInfoStackView, showChildCommentButton]).then {
    $0.axis = .vertical
    $0.spacing = 8
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupLayouts()
  }
  
  
  private func setupLayouts() {
    self.contentView.addSubview(profileImageView)
    self.contentView.addSubview(commentLabel)
    self.contentView.addSubview(commentStackView)
    
    profileImageView.snp.makeConstraints { make in
      make.size.equalTo(34)
      make.leading.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(12)
    }
    
    commentLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.equalTo(profileImageView.snp.trailing).offset(12)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    commentStackView.snp.makeConstraints { make in
      make.top.equalTo(commentLabel.snp.bottom).offset(8)
      make.leading.equalTo(profileImageView.snp.trailing).offset(12)
      make.bottom.equalToSuperview().offset(-12)
    }
  }
  
  public func setupCellConfigure(
    profileUrl: String,
    userName: String,
    comment: String,
    createdAt: Int,
    childReplyCount: Int
  ) {
    
    profileImageView.loadLowQualityImage(imageUrl: profileUrl)
    
    if childReplyCount == 0 { showChildCommentButton.isHidden = true }
    else {
      showChildCommentButton.isHidden = false
      showChildCommentButton.text = "답글 \(childReplyCount)개 보기"
    }
    
    let userName: String = "\(userName) "
    let userComment: String = comment
    
    let userNameAttributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: UIFont.DecoFont.getFont(with: .NotoSans, type: .bold, size: 12),
      NSAttributedString.Key.foregroundColor: UIColor.DecoColor.gray4
    ]
    
    let userCommentAttributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: UIFont.DecoFont.getFont(with: .NotoSans, type: .regular, size: 12),
      NSAttributedString.Key.foregroundColor: UIColor.DecoColor.darkGray2
    ]
    
    let commentString: String = userName + " " + userComment
    let attributedString = NSMutableAttributedString(string: commentString)
    let userNameRange = attributedString.mutableString.range(of: userName)
    let userCommentRange = attributedString.mutableString.range(of: userComment)
    attributedString.addAttributes(userNameAttributes, range: userNameRange)
    attributedString.addAttributes(userCommentAttributes, range: userCommentRange)
    
    commentLabel.attributedText = attributedString
    let date = Date().getTimeInterver(serverTime: createdAt)
    timeLabel.text = date == "0초 후" ? "방금" : date
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
