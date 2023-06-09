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
  func fetchProductList(createdAt: Int)
  func fetchAddBookmark(with productID: Int)
  func fetchDeleteBookmark(with productID: Int)
  
  func updateFilter(categoryList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)], colorList: [(name: String, id: Int, filterType: Filter, isSelected: Bool)])
  func updateBookmarkState(at index: Int, product: ProductDTO)
  
  func pushProductDetailVC(at index: Int, with productInfo: ProductDTO)
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
    $0.showsHorizontalScrollIndicator = false
    $0.isHidden = true
    $0.setupSelectionFilterLayout()
  }
  
  private let productCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(BookmarkImageCell.self, forCellWithReuseIdentifier: BookmarkImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupDefaultTwoColumnGridLayout()
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
    selectedFilterCollectionView.delegate = nil
    selectedFilterCollectionView.dataSource = nil
    
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
  }
  
  private func setProductListCollectionView() {
    productCollectionView.delegate = nil
    productCollectionView.dataSource = nil
    
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
            ToastManager.shared.showToast(.DeleteBookmark)
          } else {
            inSelf.listener?.fetchAddBookmark(with: product.id)
            ToastManager.shared.showToast(.AddBookmark)
          }
         
          let shouldInputData: ProductDTO = ProductDTO(
            name: product.name,
            imageUrl: product.imageUrl,
            brandName: product.brandName,
            id: product.id,
            scrap: !product.scrap,
            createdAt: product.createdAt
          )
          
          inSelf.listener?.updateBookmarkState(at: index, product: shouldInputData)
        }
        
      }.disposed(by: disposeBag)
    
    Observable.zip(
      productCollectionView.rx.itemSelected,
      productCollectionView.rx.modelSelected(ProductDTO.self)
    ).subscribe(onNext: { [weak self] index, product in
      guard let self else { return }
      self.listener?.pushProductDetailVC(at: index.row, with: product)
    }).disposed(by: disposeBag)
    
    productCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let productList = self.listener?.productLists.value,
           productList.count - 1 == index {
          let lastCreatedAt = productList[index].createdAt
          self.listener?.fetchProductList(createdAt: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
  }
  
  
  func setCurrentMood(mood: String) {
    self.navCategoryLabel.text = mood
    self.navCategoryLabel.flex.markDirty()
    self.navCategoryView.flex.layout(mode: .adjustWidth)
  }
}
