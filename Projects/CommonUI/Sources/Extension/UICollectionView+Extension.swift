//
//  UICollectionView+Extension.swift
//  CommonUI
//
//  Created by 구본의 on 2023/06/26.
//

import UIKit

public extension UICollectionView {
  
  /// 일반적인 사진 그리드 정렬에 사용됩니다.
  /// spacing = 5입니다
  func setupDefaultTwoColumnGridLayout() {
    let spacing: CGFloat = 5.0
    let cellSize: CGFloat = (UIScreen.main.bounds.width - spacing) / 2.0
    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cellSize), heightDimension: .absolute(cellSize))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cellSize))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(spacing)
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = spacing
    let layout = UICollectionViewCompositionalLayout(section: section)
    self.collectionViewLayout = layout
  }
}
