//
//  BrandDetailViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/22.
//

import UIKit

import Util
import Entity
import CommonUI


import RIBs
import RxSwift
import RxCocoa
import RxRelay
import PinLayout
import FlexLayout

protocol BrandDetailPresentableListener: AnyObject {
  func popBrandDetailVC(with popType: PopType)
  
  func fetchBrandPostings(brandID: Int, userID: Int, createdAt: Int) async
  
  var brandInfoData: BehaviorRelay<BrandDTO?> { get }
  var brandProductUsagePostings: BehaviorRelay<[PostingDTO]> { get }
}

final class BrandDetailViewController: UIViewController, BrandDetailPresentable, BrandDetailViewControllable {
  
  weak var listener: BrandDetailPresentableListener?
  
  private let usageCollectionViewHeight: CGFloat = (UIScreen.main.bounds.width * 164.0) / 375.0
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: false
  )
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.backgroundColor = .green
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
  }
  
  private let brandInfoHeaderView: BrandInfoHeaderView = BrandInfoHeaderView()
  
  private let brandProductUsageBaseView: UIView = UIView().then {
    $0.backgroundColor = .yellow
    $0.alpha = 0
    
  }
  private let brandProductUsageHeaderView: BrandProductUsageHeaderView = BrandProductUsageHeaderView().then {
    $0.backgroundColor = .orange
  }
  private let brandProductUsageCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .red
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
  }
  
  private let brandProductCategoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .blue
  }
  
  private let brandProductCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .cyan
  }
  
  private let stickView: UIView = UIView().then {
    $0.backgroundColor = .brown
    $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBinds()
    self.setupBrandProductUsageCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popBrandDetailVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  // MARK: - Private Method
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(brandInfoHeaderView)
    self.scrollView.addSubview(brandProductUsageBaseView)
    self.scrollView.addSubview(brandProductCategoryCollectionView)
    self.scrollView.addSubview(brandProductCollectionView)
    self.view.addSubview(stickView)
    
    brandProductUsageBaseView.flex.direction(.column).define { flex in
      flex.addItem(brandProductUsageHeaderView)
      flex.addItem(brandProductUsageCollectionView)
        .height(usageCollectionViewHeight)
    }
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    scrollView.pin
      .below(of: navigationBar)
      .horizontally()
      .bottom()
    
    brandInfoHeaderView.pin
      .top()
      .horizontally()
    
    brandProductUsageBaseView.pin
      .below(of: brandInfoHeaderView, aligned: .left)
      .horizontally()
      .marginTop(40)
    
    brandProductCategoryCollectionView.pin
      .below(of: visible([brandInfoHeaderView, brandProductUsageBaseView]), aligned: .left)
      .horizontally()
      .height(18)
      .marginTop(40)
    
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let navigationOffSet: CGFloat = navigationBar.frame.maxY
    let brandProductCollectionViewHeight: CGFloat = screenHeight - navigationOffSet
    
    brandProductCollectionView.pin
      .below(of: brandProductCategoryCollectionView, aligned: .left)
      .horizontally()
      .height(brandProductCollectionViewHeight)
    
    stickView.pin
      .below(of: navigationBar)
      .horizontally()
      .height(18)
      .bottom()
    
    brandProductUsageBaseView.flex.layout(mode: .adjustHeight)
    
    scrollView.contentSize = CGSize(
      width: view.frame.width,
      height: brandProductCollectionView.frame.maxY
    )
    
   
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popBrandDetailVC(with: .BackButton)
    }
    
    self.brandProductUsageHeaderView.didTapLinkButton = { [weak self] in
      guard let self else { return }
      print("상세 화면 이동")
    }
  }
  
  private func setupBinds() {
    self.listener?.brandInfoData
      .compactMap{$0}
      .bind { [weak self] info in
        guard let self else { return }
        self.brandInfoHeaderView.setConfigure(brandInfo: info)
      }.disposed(by: disposeBag)
      
    
    scrollView.rx.contentOffset
      .map { $0.y }
      .bind { [weak self] offsetY in
        guard let self else { return }
        
        let categoryCollectionViewMinY: CGFloat = self.brandProductCategoryCollectionView.frame.minY
        let isStickyOffset: Bool = (offsetY > categoryCollectionViewMinY)
        
        self.stickView.isHidden = !isStickyOffset
      }.disposed(by: disposeBag)
  }
}

// MARK: - BrandProductUsageCollectionView

extension BrandDetailViewController {
  private func setupBrandProductUsageCollectionView() {
    listener?.brandProductUsagePostings
      .observe(on: MainScheduler.instance)
      .filter{!$0.isEmpty}
      .map{$0.isEmpty}
      .bind { [weak self] isEmpty in
        guard let self else { return }
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut) {
          self.brandProductUsageBaseView.alpha = isEmpty ? 0 : 1
          self.setupLayouts()
        }
      }.disposed(by: disposeBag)
    
    listener?.brandProductUsagePostings
      .bind(to: brandProductUsageCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { (index, data, cell) in
        cell.setupCellData(type: .DefaultType, imageURL: data.imageUrl ?? "")
      }.disposed(by: disposeBag)
    
    brandProductUsageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}



// MARK: - CollectionView
extension BrandDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: usageCollectionViewHeight, height: usageCollectionViewHeight)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
  }
  
}
