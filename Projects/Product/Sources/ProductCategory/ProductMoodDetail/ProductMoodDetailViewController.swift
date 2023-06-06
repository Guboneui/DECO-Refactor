//
//  ProductMoodDetailViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import UIKit

import CommonUI
import Entity
import Util

import RIBs
import RxSwift
import RxRelay
import PinLayout
import FlexLayout

protocol ProductMoodDetailPresentableListener: AnyObject {
  var productLists: BehaviorRelay<[ProductDTO]> { get }
  var selectedFilter: BehaviorRelay<[(name: String, id: Int, filterType: Filter, isSelected: Bool)]> { get }
  
  func popProductMoodDetailVC(with popType: PopType)
  func showMoodModalVC()
  func showCategoryColorModalVC()
  func fetchAddBookmark(with productID: Int)
  func fetchDeleteBookmark(with productID: Int)
  
  func updateFilter(categoryList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)], colorList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)])
}

final class ProductMoodDetailViewController: UIViewController, ProductMoodDetailPresentable, ProductMoodDetailViewControllable {
  
  weak var listener: ProductMoodDetailPresentableListener?
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
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let filterLabel: UILabel = UILabel().then {
    $0.text = "카테고리 • 컬러"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray1
  }
  
  private let filterImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.filter
    $0.contentMode = .scaleAspectFit
  }
  
  private let filterView: TouchAnimationView = TouchAnimationView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let selectedFilterCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(SelectedFilterCell.self, forCellWithReuseIdentifier: SelectedFilterCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
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
    self.setSelectedFilterCollectionView()
    self.setProductListCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popProductMoodDetailVC(with: .Swipe)
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
      self.listener?.popProductMoodDetailVC(with: .BackButton)
    }
    
    self.navCategoryView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.showMoodModalVC()
      }.disposed(by: disposeBag)
    
    self.filterView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.showCategoryColorModalVC()
      }.disposed(by: disposeBag)
  }
  
  private func setSelectedFilterCollectionView() {
    self.listener?.selectedFilter
      .observe(on: MainScheduler.instance)
      .share()
      .bind { [weak self] selectedFilter in
        guard let self else { return }
        self.selectedFilterCollectionView.isHidden = selectedFilter.isEmpty
        self.setupLayouts()
      }.disposed(by: disposeBag)
    
    listener?.selectedFilter
      .bind(to: selectedFilterCollectionView.rx.items(
        cellIdentifier: SelectedFilterCell.identifier,
        cellType: SelectedFilterCell.self)
      ) { index, filter, cell in
        cell.setupCellConfigure(text: filter.name, isSelected: filter.isSelected)
      }.disposed(by: disposeBag)
    
    
    Observable.zip(
      selectedFilterCollectionView.rx.itemSelected,
      selectedFilterCollectionView.rx.modelSelected((name: String, id: Int, filterType: Filter, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, model in
      guard let self else { return }
      if index.row == 0 { self.listener?.updateFilter(categoryList: [], colorList: []) }
      else {
        var filterList = self.listener?.selectedFilter.value ?? []
        filterList.remove(at: index.row)
        
        if filterList.count == 1 { self.listener?.updateFilter(categoryList: [], colorList: []) }
        else {
          var filterList = self.listener?.selectedFilter.value ?? []
          filterList.remove(at: index.row)
          let categoryList = filterList.filter{$0.filterType == .Category}
          let colorList = filterList.filter{$0.filterType == .Color}
          self.listener?.updateFilter(categoryList: categoryList, colorList: colorList)
        }
      }
    }).disposed(by: disposeBag)
    
    selectedFilterCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setProductListCollectionView() {
    listener?.productLists
      .bind(to: productCollectionView.rx.items(
        cellIdentifier: BookmarkImageCell.identifier,
        cellType: BookmarkImageCell.self)
      ) { [weak self] index, product, cell in
        guard let self else { return }
        cell.setupCellConfigure(imageURL: product.imageUrl, isBookmarked: product.scrap)
        
        cell.didTapBookmarkButton = { [weak self] in
          guard let inSelf = self else { return }
          if product.scrap {
            inSelf.listener?.fetchDeleteBookmark(with: product.id)
          } else {
            inSelf.listener?.fetchAddBookmark(with: product.id)
          }
         
          let shouldInputData: ProductDTO = ProductDTO(
            name: product.name,
            imageUrl: product.imageUrl,
            brandName: product.brandName,
            id: product.id,
            scrap: !product.scrap,
            createdAt: product.createdAt
          )
          var productList = inSelf.listener?.productLists.value ?? []
          productList[index] = shouldInputData
          inSelf.listener?.productLists.accept(productList)
        }
        
      }.disposed(by: disposeBag)
    
    productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  
  func setCurrentMood(mood: String) {
    self.navCategoryLabel.text = mood
    self.navCategoryLabel.flex.markDirty()
    self.navCategoryView.flex.layout(mode: .adjustWidth)
  }
}

extension ProductMoodDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case selectedFilterCollectionView:
      let font: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .medium, size: 12)
      if let categoryList = listener?.selectedFilter.value {
        return CGSize(
          width: (
            (categoryList[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font:font]).width) +
            (SelectedFilterCell.horizontalMargin * 2) +
            (SelectedFilterCell.imageSize) +
            (SelectedFilterCell.itemSpacing)
          ),
          height: 30
        )
      }
      return .zero
      
    case productCollectionView:
      let cellSize: CGFloat = (UIScreen.main.bounds.width - 5.0) / 2.0
      return CGSize(width: cellSize, height: cellSize)
    default: return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView {
    case selectedFilterCollectionView: return 8.0
    case productCollectionView: return 5.0
    default: return .zero
    }
    
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView {
    case selectedFilterCollectionView: return 8.0
    case productCollectionView: return 5.0
    default: return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch collectionView {
    case selectedFilterCollectionView: return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    case productCollectionView: return UIEdgeInsets.zero
    default: return UIEdgeInsets.zero
    }
  }
}
