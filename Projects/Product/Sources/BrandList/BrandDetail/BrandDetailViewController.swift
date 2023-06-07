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
  func pushBrandProductUsageVC()
  
  func fetchBrandPostings(brandID: Int, userID: Int, createdAt: Int) async
  
  var brandInfoData: BehaviorRelay<BrandDTO?> { get }
  var brandProductUsagePostings: BehaviorRelay<[PostingDTO]> { get }
  var productCategory: BehaviorRelay<[ProductCategoryDTO]> { get }
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
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
  }
  
  private let brandInfoHeaderView: BrandInfoHeaderView = BrandInfoHeaderView()
  
  private let brandProductUsageBaseView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.alpha = 0
    
  }
  private let brandProductUsageHeaderView: BrandProductUsageHeaderView = BrandProductUsageHeaderView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  private let brandProductUsageCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
  }
  
  private let brandProductCategoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(SmallTextCell.self, forCellWithReuseIdentifier: SmallTextCell.identifier)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  private let brandProductCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .cyan
  }
  
  private let stickyCategoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(SmallTextCell.self, forCellWithReuseIdentifier: SmallTextCell.identifier)
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    $0.isHidden = true
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBinds()
    self.setupBrandProductUsageCollectionView()
    self.setupProductCategoryCollectionView()
    self.setupStickyCategoryCollectionView()
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
    self.view.addSubview(stickyCategoryCollectionView)
    
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
    
    stickyCategoryCollectionView.pin
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
      self.listener?.pushBrandProductUsageVC()
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
        
        self.stickyCategoryCollectionView.isHidden = !isStickyOffset
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
        UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveEaseInOut) { [weak self] in
          guard let inSelf = self else { return }
          inSelf.brandProductUsageBaseView.alpha = isEmpty ? 0 : 1
          inSelf.setupLayouts()
        }
      }.disposed(by: disposeBag)
    
    listener?.brandProductUsagePostings
      .bind(to: brandProductUsageCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(type: .DefaultType, imageURL: data.imageUrl ?? "")
      }.disposed(by: disposeBag)
    
    brandProductUsageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

// MARK: - ProductCategoryCollectionView

extension BrandDetailViewController {
  private func setupProductCategoryCollectionView() {
    listener?.productCategory
      .bind(to: brandProductCategoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(text: data.categoryName, isSelected: true)
      }.disposed(by: disposeBag)
    
    brandProductCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

// MARK: - StickyCategoryCollectionView

extension BrandDetailViewController {
  private func setupStickyCategoryCollectionView() {
    listener?.productCategory
      .bind(to: stickyCategoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(text: data.categoryName, isSelected: true)
      }.disposed(by: disposeBag)
    
    stickyCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}


// MARK: - CollectionView
extension BrandDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    
    switch collectionView {
    case brandProductUsageCollectionView:
      return CGSize(width: usageCollectionViewHeight, height: usageCollectionViewHeight)
    case brandProductCategoryCollectionView, stickyCategoryCollectionView:
      let font: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .medium, size: 12)
      
      if let productCategory = listener?.productCategory.value {
        return CGSize(
          width: productCategory[indexPath.row].categoryName.size(withAttributes: [NSAttributedString.Key.font:font]).width + 20,
          height: 15
        )
      } else {
        return .zero
      }
    default:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView {
    case brandProductUsageCollectionView:
      return 8.0
    case brandProductCategoryCollectionView, stickyCategoryCollectionView:
      return 24.0
    default:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
  }
}
