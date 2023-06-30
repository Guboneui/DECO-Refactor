//
//  BrandProductUsageViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/24.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol BrandProductUsagePresentableListener: AnyObject {
  func popBrandProductUsageVC(with popType: PopType)
  func fetchBrandPostings(createdAt: Int) async
  
  var brandProductUsagePosting: BehaviorRelay<[PostingDTO]> { get }
}

final class BrandProductUsageViewController: UIViewController, BrandProductUsagePresentable, BrandProductUsageViewControllable {
  
  weak var listener: BrandProductUsagePresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private struct CollectionViewMetric {
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let horizontalSpacing: CGFloat = 16
    let lineSpacing: CGFloat = 5.0
  }
  
  private let collectionViewMetric: CollectionViewMetric = CollectionViewMetric()
  
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: true
  )
  
  private let brandProductUsageCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    $0.setupDefaultTwoColumnGridLayoutWithHorizontalMargin()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setBrandProductUsageCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popBrandProductUsageVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  // MARK: - Private Method
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(brandProductUsageCollectionView)
    
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    brandProductUsageCollectionView.pin
      .below(of: navigationBar)
      .horizontally()
      .bottom()
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popBrandProductUsageVC(with: .BackButton)
    }
  }
  
  func setNavTitleWithBrandName(with title: String) {
    self.navigationBar.setNavigationBarTitle(with: title)
  }
  
  func setBrandProductUsageCollectionView() {
    brandProductUsageCollectionView.delegate = nil
    brandProductUsageCollectionView.dataSource = nil
    
    listener?.brandProductUsagePosting
      .bind(to: brandProductUsageCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(type: .DefaultType, imageURL: data.imageUrl ?? "")
      }.disposed(by: disposeBag)

    brandProductUsageCollectionView.rx.willDisplayCell
      .map{$0.at}
      .subscribe(onNext: { [weak self] indexPath in
        guard let self else { return }
        
        if let potings = self.listener?.brandProductUsagePosting.value,
           potings.count - 1 == indexPath.row,
           let lastCreatedAt = potings[indexPath.row].createdAt {
        
          Task.detached {
            await self.listener?.fetchBrandPostings(createdAt: lastCreatedAt)
          }
        }
      }).disposed(by: disposeBag)
  }
}
