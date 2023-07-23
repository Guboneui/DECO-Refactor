//
//  SearchView.swift
//  CommonUI
//
//  Created by 구본의 on 2023/07/24.
//

import UIKit
import SnapKit

public enum SearchViewType {
  case HOME
  case PRODUCT
}

public class SearchView: UIView {
  
  private let type: SearchViewType
  private let cornerRadius: CGFloat
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.search
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .DecoColor.gray2
  }
  
  private let searchLabel: UILabel = UILabel().then {
    $0.text = "브랜드 및 상품 검색하기"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.gray1
  }
  
  public init(
    type: SearchViewType,
    cornerRadius: CGFloat
  ) {
    self.type = type
    self.cornerRadius = cornerRadius
    super.init(frame: .zero)
    self.setupViews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.backgroundColor = .DecoColor.lightGray1
    self.makeCornerRadius(radius: cornerRadius)
  }
  
  private func setupLayouts() {
    self.addSubview(searchImageView)
    self.addSubview(searchLabel)
    
    searchImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(type == .HOME ? 10 : 14)
      make.size.equalTo(20)
    }
    
    searchLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(searchImageView.snp.trailing).offset(type == .HOME ? 10 : 20)
      make.trailing.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
