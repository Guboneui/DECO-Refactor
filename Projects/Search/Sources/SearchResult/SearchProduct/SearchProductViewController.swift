//
//  SearchProductViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import UIKit

import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
import PinLayout
import FlexLayout

protocol SearchProductPresentableListener: AnyObject {
  
  var productList: BehaviorRelay<[ProductDTO]> { get }
  
  func fetchProductList(createdAt: Int)
  func fetchAddBookmark(with productID: Int)
  func fetchDeleteBookmark(with productID: Int)
  func updateBookmarkState(at index: Int, product: ProductDTO)
  func showFilterModalVC()
  func pushProductDetailVC(at index: Int, with productInfo: ProductDTO)
}

final class SearchProductViewController: UIViewController, SearchProductPresentable, SearchProductViewControllable {
  
  weak var listener: SearchProductPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let filterLabel: UILabel = UILabel().then {
    $0.text = "카테고리 • 무드 • 컬러"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray1
    $0.sizeToFit()
  }
  
  private let filterImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.filter
    $0.contentMode = .scaleAspectFit
  }
  
  private let filterFlexView: TouchAnimationView = TouchAnimationView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let selectedFilterCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(SelectedFilterCell.self, forCellWithReuseIdentifier: SelectedFilterCell.identifier)
    $0.backgroundColor = .DecoColor.kakaoColor
    $0.bounces = false
    $0.showsHorizontalScrollIndicator = false
    $0.isHidden = false
    $0.setupSelectionFilterLayout()
  }
  
  private let productCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(BookmarkImageCell.self, forCellWithReuseIdentifier: BookmarkImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupDefaultTwoColumnGridLayout()
    $0.showsVerticalScrollIndicator = false
  }
  
  let emptyNoticeLabel: UILabel = UILabel().then {
    $0.isHidden = true
    $0.makeEmptySearchResultNoticeText()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
    self.setupProductCollectionView()
  }
  
  private func setupViews() {
    self.view.addSubview(filterFlexView)
    self.view.addSubview(selectedFilterCollectionView)
    self.view.addSubview(productCollectionView)
    self.view.addSubview(emptyNoticeLabel)
    
    filterFlexView.flex.direction(.row).define { flex in
      flex.addItem(filterLabel)
      flex.addItem(filterImageView).size(26).marginLeft(4)
    }
  }
  
  private func setupLayouts() {
    filterFlexView.pin
      .topRight()
      .height(26)
      .width(filterLabel.frame.width + 30)
      .marginRight(12)
      .marginTop(8)
    
    selectedFilterCollectionView.pin
      .below(of: filterFlexView)
      .horizontally()
      .height(30)
      .marginTop(18)
    
    productCollectionView.pin
      .below(of: visible([filterFlexView, selectedFilterCollectionView]))
      .horizontally()
      .bottom()
      .marginTop(selectedFilterCollectionView.isHidden ? 8 : 12)
    
    emptyNoticeLabel.pin
      .center()
      .sizeToFit()
    
    filterFlexView.flex.layout(mode: .adjustHeight)
  }
  
  private func setupGestures() {
    filterFlexView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.showFilterModalVC()
      }.disposed(by: disposeBag)
  }
  
  private func setupProductCollectionView() {
    productCollectionView.delegate = nil
    productCollectionView.dataSource = nil
    
    listener?.productList
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
          
          inSelf.listener?.updateBookmarkState(
            at: index,
            product: shouldInputData
          )
        }
      }.disposed(by: disposeBag)
    
    productCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let productList = self.listener?.productList.value,
           productList.count - 1 == index {
          let lastCreatedAt = productList[index].createdAt
          self.listener?.fetchProductList(createdAt: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
    
    Observable.zip(
      productCollectionView.rx.itemSelected,
      productCollectionView.rx.modelSelected(ProductDTO.self)
    ).subscribe(onNext: { [weak self] index, product in
      guard let self else { return }
      print(index, product)
      self.listener?.pushProductDetailVC(at: index.row, with: product)
    }).disposed(by: disposeBag)
  }
  
  func showEmptyNotice() {
    self.productCollectionView.isHidden = true
    self.emptyNoticeLabel.isHidden = false
  }
}
