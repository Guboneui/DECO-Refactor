//
//  SearchPhotoViewController.swift
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

protocol SearchPhotoPresentableListener: AnyObject {
  var photoList: BehaviorRelay<[PostingDTO]> { get }
  
  func fetchPhotoList(createdAt: Int)
}

final class SearchPhotoViewController: UIViewController, SearchPhotoPresentable, SearchPhotoViewControllable {
  
  weak var listener: SearchPhotoPresentableListener?
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
    $0.backgroundColor = .DecoColor.warningColor
    $0.bounces = false
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.showsHorizontalScrollIndicator = false
    $0.isHidden = false
  }
  
  private let photoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
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
    self.setupPhotoCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(filterFlexView)
    self.view.addSubview(selectedFilterCollectionView)
    self.view.addSubview(photoCollectionView)
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
    
    photoCollectionView.pin
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
        print("필터 클릭")
        
      }.disposed(by: disposeBag)
  }
  
  private func setupPhotoCollectionView() {
    photoCollectionView.delegate = nil
    photoCollectionView.dataSource = nil
    
    listener?.photoList
      .bind(to: photoCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { [weak self] index, photo, cell in
        guard let self else { return }
        cell.setupCellConfigure(type: .DefaultType, imageURL: photo.imageUrl ?? "")
      }.disposed(by: disposeBag)
    
    photoCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let photoList = self.listener?.photoList.value,
           photoList.count - 1 == index {
          let lastCreatedAt = photoList[index].likeSort ?? Int.max
          self.listener?.fetchPhotoList(createdAt: lastCreatedAt)
        }
        
      }).disposed(by: disposeBag)
    
    photoCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  func showEmptyNotice() {
    self.photoCollectionView.isHidden = true
    self.emptyNoticeLabel.isHidden = false
  }
}

extension SearchPhotoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets.zero
  }
}
