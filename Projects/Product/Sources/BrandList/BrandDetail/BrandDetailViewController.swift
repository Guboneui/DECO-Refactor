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
  
  func fetchBrandPostings(createdAt: Int)
  
  var brandInfoData: BehaviorRelay<BrandDTO?> { get }
  var brandProductUsagePostings: BehaviorRelay<[PostingDTO]> { get }
  var productCategory: BehaviorRelay<[(category: ProductCategoryDTO, isSelected: Bool)]> { get }
  var categoryVCs: BehaviorRelay<[ViewControllable]> { get }
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
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(ChildViewCell.self, forCellWithReuseIdentifier: ChildViewCell.identifier)
    $0.bounces = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
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
    self.setupBrandProductCollectionView()
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
    
    stickyCategoryCollectionView.pin
      .below(of: navigationBar)
      .horizontally()
      .height(18)
      .bottom()
    
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let stickyCategoryCvOffset: CGFloat = stickyCategoryCollectionView.frame.maxY
    let brandProductCollectionViewHeight: CGFloat = screenHeight - stickyCategoryCvOffset
    
    brandProductCollectionView.pin
      .below(of: brandProductCategoryCollectionView, aligned: .left)
      .horizontally()
      .height(brandProductCollectionViewHeight)
    
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
    brandProductUsageCollectionView.delegate = nil
    brandProductUsageCollectionView.dataSource = nil
    
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
    
    brandProductUsageCollectionView.rx.willDisplayCell
      .map{$0.at}
      .subscribe(onNext: { [weak self] indexPath in
        guard let self else { return }
        if let postings = self.listener?.brandProductUsagePostings.value,
           postings.count - 1 == indexPath.row,
           let lastCreatedAt = postings[indexPath.row].createdAt {
          self.listener?.fetchBrandPostings(createdAt: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
    
    brandProductUsageCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

// MARK: - ProductCategoryCollectionView

extension BrandDetailViewController {
  private func setupProductCategoryCollectionView() {
    
    brandProductCategoryCollectionView.delegate = nil
    brandProductCategoryCollectionView.dataSource = nil
    
    listener?.productCategory
      .bind(to: brandProductCategoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(text: data.category.categoryName, isSelected: data.isSelected)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      brandProductCategoryCollectionView.rx.itemSelected,
      brandProductCategoryCollectionView.rx.modelSelected((category: ProductCategoryDTO, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, category in
      guard let self else { return }
      var updatedCategory = self.listener?.productCategory.value.map{($0.category, false)} ?? []
      let selectedCategory = (category.category, true)
      updatedCategory[index.row] = selectedCategory
      self.listener?.productCategory.accept(updatedCategory)
    }).disposed(by: disposeBag)
    
    
    
    brandProductCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

// MARK: - StickyCategoryCollectionView

extension BrandDetailViewController {
  private func setupStickyCategoryCollectionView() {
    stickyCategoryCollectionView.delegate = nil
    stickyCategoryCollectionView.dataSource = nil
    
    listener?.productCategory
      .bind(to: stickyCategoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(text: data.category.categoryName, isSelected: data.isSelected)
      }.disposed(by: disposeBag)
    
    
    Observable.zip(
      stickyCategoryCollectionView.rx.itemSelected,
      stickyCategoryCollectionView.rx.modelSelected((category: ProductCategoryDTO, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, category in
      guard let self else { return }
      var updatedCategory = self.listener?.productCategory.value.map{($0.category, false)} ?? []
      let selectedCategory = (category.category, true)
      updatedCategory[index.row] = selectedCategory
      self.listener?.productCategory.accept(updatedCategory)
    }).disposed(by: disposeBag)
    
    
   
    stickyCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension BrandDetailViewController {
  private func setupBrandProductCollectionView() {
    brandProductCollectionView.delegate = nil
    brandProductCollectionView.dataSource = nil
    
    listener?.categoryVCs
      .bind(to: brandProductCollectionView.rx.items(
        cellIdentifier: ChildViewCell.identifier,
        cellType: ChildViewCell.self)
      ) { [weak self] index, childVC, cell in
        guard let self else { return }
        
      }.disposed(by: disposeBag)
    
    brandProductCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
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
          width: productCategory[indexPath.row].category.categoryName.size(withAttributes: [NSAttributedString.Key.font:font]).width + 20,
          height: 15
        )
      } else {
        return .zero
      }
    case brandProductCollectionView:
      print(brandProductCollectionView.frame)
      return CGSize(
        width: brandProductCollectionView.frame.width,
        height: brandProductCollectionView.frame.height
      )
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
    case brandProductCollectionView:
      return .zero
    default:
      return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch collectionView {
    case brandProductCollectionView:
      return .zero
    default: return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
    }
    
  }
}
