//
//  ProductCategoryDetailViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import UIKit

import Util
import Entity
import CommonUI


import RIBs
import RxSwift
import RxRelay
import PinLayout
import FlexLayout

protocol ProductCategoryDetailPresentableListener: AnyObject {
  var productLists: BehaviorRelay<[ProductDTO]> { get }
  
  func popProductCategoryDetailDetailVC(with popType: PopType)
  func showCategoryModalVC()
  func showMoodColorModalVC()
  
  func fetchProductList(createdAt: Int)
}

final class ProductCategoryDetailViewController: UIViewController, ProductCategoryDetailPresentable, ProductCategoryDetailViewControllable {
  
  weak var listener: ProductCategoryDetailPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: true
  )
  
  private let navCategoryLabel: UILabel = UILabel().then {
    $0.text = "카테고리"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let navDropDownImage: UIImageView = UIImageView().then {
    $0.image = .DecoImage.listupDarkgray2
    $0.contentMode = .scaleAspectFit
  }
  
  private var navCategoryView: TouchAnimationView = TouchAnimationView().then {
    $0.backgroundColor = .orange
  }
  
  private let filterLabel: UILabel = UILabel().then {
    $0.text = "무드 • 컬러"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray1
  }
  
  private let filterImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.filter
    $0.contentMode = .scaleAspectFit
  }
  
  private let filterView: TouchAnimationView = TouchAnimationView().then {
    $0.backgroundColor = .green
  }
  
  private let selectedFilterCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .yellow
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.isHidden = true
  }
  
  private let productCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(BookmarkImageCell.self, forCellWithReuseIdentifier: BookmarkImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setProductListCollectionView()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
      guard let self else { return }
      self.selectedFilterCollectionView.isHidden = false
      self.setupLayouts()
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popProductCategoryDetailDetailVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.navigationBar.addSubview(navCategoryView)
    self.view.addSubview(filterView)
    self.view.addSubview(selectedFilterCollectionView)
    self.view.addSubview(productCollectionView)
    
    navCategoryView.flex.direction(.row).alignItems(.center).define { flex in
      flex.addItem(navCategoryLabel)
      flex.addItem(navDropDownImage).size(13).marginLeft(8)
    }
    
    filterView.flex.direction(.row).alignItems(.center).define { flex in
      flex.addItem(filterLabel)
      flex.addItem(filterImageView).size(26).marginLeft(4)
    }
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    navCategoryView.pin
      .left(84)
      .vCenter()
      .height(20)
    
    filterView.pin
      .below(of: navigationBar, aligned: .right)
      .height(26)
      .marginRight(12)
      .marginTop(12)
    
    selectedFilterCollectionView.pin
      .below(of: filterView)
      .horizontally()
      .height(30)
      .marginTop(24)
    
    productCollectionView.pin
      .below(of: visible([filterView, selectedFilterCollectionView]))
      .horizontally()
      .bottom()
      .marginTop(12)
    
    navCategoryView.flex.layout(mode: .adjustWidth)
    filterView.flex.layout(mode: .adjustWidth)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popProductCategoryDetailDetailVC(with: .BackButton)
    }
    
    self.navCategoryView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.showCategoryModalVC()
      }.disposed(by: disposeBag)
    
    self.filterView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.showMoodColorModalVC()
        
      }.disposed(by: disposeBag)
  }
  
  private func setProductListCollectionView() {
    listener?.productLists
      .bind(to: productCollectionView.rx.items(
        cellIdentifier: BookmarkImageCell.identifier,
        cellType: BookmarkImageCell.self)
      ) { index, product, cell in
        cell.setupCellConfigure(imageURL: product.imageUrl, isBookmarked: product.scrap)
      }.disposed(by: disposeBag)
    
    productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  // MARK: - ProductCategoryDetailPresentable
  func setCurrentCategory(category: String) {
    self.navCategoryLabel.text = category
    self.navCategoryLabel.flex.markDirty()
    self.navCategoryView.flex.layout(mode: .adjustWidth)
  }
}

extension ProductCategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellSize: CGFloat = (UIScreen.main.bounds.width - 5.0) / 2.0
    return CGSize(width: cellSize, height: cellSize)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 5.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 5.0
  }
}
