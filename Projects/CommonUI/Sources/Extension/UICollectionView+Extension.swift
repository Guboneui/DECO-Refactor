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
  
  func setupSelectionFilterLayout() {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    config.interSectionSpacing = 0
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let estimatedWidth: CGFloat = 20.0
    let absoluteHeight: CGFloat = 30.0
    let spacing: CGFloat = 8.0
    let inset: CGFloat = 18.0
    
    let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .absolute(absoluteHeight))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
      let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth), heightDimension: .absolute(absoluteHeight))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .fixed(spacing)
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = spacing
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)

      return section
    }, configuration: config)
    self.collectionViewLayout = layout
  }
  
  func setupSmallCategoryLayout() {
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    config.interSectionSpacing = 0
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let estimatedWidth: CGFloat = 15.0
    let absoluteHeight: CGFloat = 15.0
    let spacing: CGFloat = 24.0
    let inset: CGFloat = 28.0
    
    let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .absolute(absoluteHeight))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
      let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(screenWidth), heightDimension: .absolute(absoluteHeight))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .fixed(spacing)
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = spacing
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)

      return section
    }, configuration: config)
    self.collectionViewLayout = layout
  }
  
  func setupDefaultListLayout(cellHeight: CGFloat, groupInset: NSDirectionalEdgeInsets = .zero, groupSpacing: CGFloat = 0, sectionInset: NSDirectionalEdgeInsets = .zero) {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cellHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cellHeight))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.contentInsets = groupInset
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = sectionInset
    section.interGroupSpacing = groupSpacing
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    self.collectionViewLayout = layout
  }
}
