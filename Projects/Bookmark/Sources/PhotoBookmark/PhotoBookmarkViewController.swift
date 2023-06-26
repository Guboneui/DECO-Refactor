//
//  PhotoBookmarkViewController.swift
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

protocol PhotoBookmarkPresentableListener: AnyObject {
  var currentSelectedCategory: Int { get }
  var photoBookmarkCategory: BehaviorRelay<[(category: BoardCategoryDTO, isSelected: Bool)]> { get }
  var photoBookmarkList: BehaviorRelay<[(bookmarkData: BookmarkDTO, isBookmark: Bool)]> { get }
  
  func selectPhotoBookmarkCategory(categoryID: Int, index: Int)
  func fetchBookmarkListWithCategory(categoryID: Int, createdAt: Int)
  func fetchAddBookmark(with boardID: Int)
  func fetchDeleteBookmark(with boardID: Int)
}

final class PhotoBookmarkViewController: UIViewController, PhotoBookmarkPresentable, PhotoBookmarkViewControllable {
  
  weak var listener: PhotoBookmarkPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let photoBookmarkCategoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    
    $0.register(SmallTextCell.self, forCellWithReuseIdentifier: SmallTextCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    $0.setupSmallCategoryLayout()
  }
  
  private let photoBookmarkCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
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
    self.view.addSubview(photoBookmarkCategoryCollectionView)
    self.view.addSubview(photoBookmarkCollectionView)
  }
  
  private func setupLayouts() {
    photoBookmarkCategoryCollectionView.pin
      .top()
      .horizontally()
      .height(18)
    
    photoBookmarkCollectionView.pin
      .below(of: photoBookmarkCategoryCollectionView)
      .horizontally()
      .bottom()
      .marginTop(10)
  }
  
  private func setupCategoryCollectionView() {
    photoBookmarkCollectionView.delegate = nil
    photoBookmarkCollectionView.dataSource = nil
    
    listener?.photoBookmarkCategory
      .bind(to: photoBookmarkCategoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { index, data, cell in
        cell.setupCellConfigure(text: data.category.categoryName, isSelected: data.isSelected)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      photoBookmarkCategoryCollectionView.rx.modelSelected((category: BoardCategoryDTO, Bool).self),
      photoBookmarkCategoryCollectionView.rx.itemSelected
    ).throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .map{($0.0.category.id, $0.1.row)}
      .subscribe(onNext: { [weak self] (selectedCategoryID, selectedIndex) in
        guard let self else { return }
        self.listener?.photoBookmarkList.accept([])
        self.listener?.fetchBookmarkListWithCategory(categoryID: selectedCategoryID, createdAt: Int.max)
        self.listener?.selectPhotoBookmarkCategory(categoryID: selectedCategoryID, index: selectedIndex)
      }).disposed(by: disposeBag)
  }
  
  private func setupBookmarkCollectionView() {
    photoBookmarkCollectionView.delegate = nil
    photoBookmarkCollectionView.dataSource = nil
    
    listener?.photoBookmarkList
      .bind(to: photoBookmarkCollectionView.rx.items(
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
            inSelf.listener?.fetchDeleteBookmark(with: data.bookmarkData.scrap.boardId)
            ToastManager.shared.showToast(.DeleteBookmark)
          } else {
            inSelf.listener?.fetchAddBookmark(with: data.bookmarkData.scrap.boardId)
            ToastManager.shared.showToast(.AddBookmark)
          }

          let shouldInputData: (BookmarkDTO, Bool) = (data.bookmarkData, !data.isBookmark)
          var bookmarkList = inSelf.listener?.photoBookmarkList.value ?? []
          bookmarkList[index] = shouldInputData
          inSelf.listener?.photoBookmarkList.accept(bookmarkList)
        }
      }.disposed(by: disposeBag)
    
    photoBookmarkCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let bookmarkLists = self.listener?.photoBookmarkList.value,
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
