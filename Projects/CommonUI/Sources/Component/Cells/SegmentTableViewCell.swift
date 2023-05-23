//
//  SegmentTableViewCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/23.
//

import UIKit



public class SegmentTableViewCell: UITableViewCell {
  
  public static let identifier: String = "SegmentTableViewCell"
  
  private let segmentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .red
  }
  
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupViews()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupLayouts()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.contentView.addSubview(segmentCollectionView)
  }
  
  private func setupLayouts() {
    segmentCollectionView.pin
      .all()
    
    contentView.pin.wrapContent(.vertically)
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: UIScreen.main.bounds.height)
  }
  
  
  
}
