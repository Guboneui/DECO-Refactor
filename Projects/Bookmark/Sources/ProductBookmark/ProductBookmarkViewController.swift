//
//  ProductBookmarkViewController.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import UIKit

import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
import PinLayout

protocol ProductBookmarkPresentableListener: AnyObject {
  var currentSelectedCategory: Int { get }
  var productBookmarkCategory: BehaviorRelay<[(category: ProductCategoryDTO, isSelected: Bool)]> { get }
  var productBookmarkList: BehaviorRelay<[(bookmarkData: BookmarkDTO, isBookmark: Bool)]> { get }
  
  func selectProductBookmarkCategory(categoryID: Int, index: Int)
  func fetchBookmarkListWithCategory(categoryID: Int, createdAt: Int)
  func fetchAddBookmark(with productID: Int)
  func fetchDeleteBookmark(with productID: Int)
}

final class ProductBookmarkViewController: UIViewController, ProductBookmarkPresentable, ProductBookmarkViewControllable {
  
  weak var listener: ProductBookmarkPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let productBookmarkCategoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    
    $0.register(SmallTextCell.self, forCellWithReuseIdentifier: SmallTextCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
  }
  
  private let productBookmarkCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(BookmarkImageCell.self, forCellWithReuseIdentifier: BookmarkImageCell.identifier)
    $0.bounces = false
    $0.setupDefaultTwoColumnGridLayout()
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupCategoryCollectionView()
    self.setupBookmarkCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(productBookmarkCategoryCollectionView)
    self.view.addSubview(productBookmarkCollectionView)
  }
  
  private func setupLayouts() {
    productBookmarkCategoryCollectionView.pin
      .top()
      .horizontally()
      .height(18)
    
    productBookmarkCollectionView.pin
      .below(of: productBookmarkCategoryCollectionView)
      .horizontally()
      .bottom()
      .marginTop(10)
  }
  
  private func setupCategoryCollectionView() {
    productBookmarkCategoryCollectionView.delegate = nil
    productBookmarkCategoryCollectionView.dataSource = nil
    
    listener?.productBookmarkCategory
      .bind(to: productBookmarkCategoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { index, data, cell in
        cell.setupCellConfigure(text: data.category.categoryName, isSelected: data.isSelected)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      productBookmarkCategoryCollectionView.rx.modelSelected((category: ProductCategoryDTO, Bool).self),
      productBookmarkCategoryCollectionView.rx.itemSelected
    ).throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .map{($0.0.category.id, $0.1.row)}
      .subscribe(onNext: { [weak self] (selectedCategoryID, selectedIndex) in
        guard let self else { return }
        self.listener?.productBookmarkList.accept([])
        self.listener?.fetchBookmarkListWithCategory(categoryID: selectedCategoryID, createdAt: Int.max)
        self.listener?.selectProductBookmarkCategory(categoryID: selectedCategoryID, index: selectedIndex)
      }).disposed(by: disposeBag)
    
    productBookmarkCategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setupBookmarkCollectionView() {
    productBookmarkCollectionView.delegate = nil
    productBookmarkCollectionView.dataSource = nil
    
    listener?.productBookmarkList
      .bind(to: productBookmarkCollectionView.rx.items(
        cellIdentifier: BookmarkImageCell.identifier,
        cellType: BookmarkImageCell.self)
      ) { [weak self] index, data, cell in
        guard let self else { return }
        cell.setupCellConfigure(
          imageURL: data.bookmarkData.imageUrl,
          isBookmarked: data.isBookmark
        )
        
        cell.didTapBookmarkButton = { [weak self] in
          guard let inSelf = self else { return }
          if data.isBookmark {
            inSelf.listener?.fetchDeleteBookmark(with: data.bookmarkData.scrap.productId)
            ToastManager.shared.showToast(.DeleteBookmark)
          } else {
            inSelf.listener?.fetchAddBookmark(with: data.bookmarkData.scrap.productId)
            ToastManager.shared.showToast(.AddBookmark)
          }
          
          let shouldInputData: (BookmarkDTO, Bool) = (data.bookmarkData, !data.isBookmark)
          var bookmarkList = inSelf.listener?.productBookmarkList.value ?? []
          bookmarkList[index] = shouldInputData
          inSelf.listener?.productBookmarkList.accept(bookmarkList)
        }
      }.disposed(by: disposeBag)
    
    productBookmarkCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let bookmarkLists = self.listener?.productBookmarkList.value,
           bookmarkLists.count - 1 == index {
          let lastCreatedAt = bookmarkLists[index].bookmarkData.scrap.createdAt
          self.listener?.fetchBookmarkListWithCategory(
            categoryID: self.listener?.currentSelectedCategory ?? -1,
            createdAt: lastCreatedAt
          )
        }
      }).disposed(by: disposeBag)
  }
}

extension ProductBookmarkViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case productBookmarkCategoryCollectionView:
      let font: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .medium, size: 12)
      if let productBookmarkCategory = listener?.productBookmarkCategory.value {
        return CGSize(
          width: productBookmarkCategory[indexPath.row].category.categoryName.size(withAttributes: [NSAttributedString.Key.font:font]).width + 24,
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
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch collectionView {
    case productBookmarkCategoryCollectionView:
      return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 4)
    default:
      return .zero
    }
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
