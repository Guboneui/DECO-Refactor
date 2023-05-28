//
//  ChildViewCell.swift
//  CommonUI
//
//  Created by 구본의 on 2023/05/29.
//

import UIKit

public class ChildViewCell: UICollectionViewCell {
  
  public static let identifier = "ChildViewCell"
  
  public override init(frame: CGRect) {
    super.init(frame: frame)

  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  public override func layoutSubviews() {
    super.layoutSubviews()  
  }
  
  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: size.height)
  }
  
  public func setupCellData(childVC: UIViewController) {
    contentView.addSubview(childVC.view)
    childVC.view.frame = self.contentView.bounds
    childVC.view.pin.all()
  }
}




