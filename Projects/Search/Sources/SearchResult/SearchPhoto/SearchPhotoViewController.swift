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
  var selectedFilter: BehaviorRelay<[(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)]> { get }
  
  func showFilterModalVC()
  func fetchPhotoList(createdAt: Int)
  func updateFilter(
    cateogryList: [(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)],
    moodList: [(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)],
    colorList: [(name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool)]
  )
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
  
  private let filterFlexView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.isHidden = true
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
  
  private let photoCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
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
    self.setupFilterCollectionView()
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
        self.listener?.showFilterModalVC()
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
  }
  
  func showEmptyNotice(isEmpty: Bool) {
    if isEmpty {
      self.photoCollectionView.isHidden = true
      self.emptyNoticeLabel.isHidden = false
    } else {
      self.photoCollectionView.isHidden = false
      self.emptyNoticeLabel.isHidden = true
    }
    
  }
  
  func showFilterView() {
    self.filterFlexView.isHidden = false
    self.setupLayouts()
  }
  
  private func setupFilterCollectionView() {
    selectedFilterCollectionView.delegate = nil
    selectedFilterCollectionView.dataSource = nil
    
    listener?.selectedFilter
      .observe(on: MainScheduler.instance)
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
      selectedFilterCollectionView.rx.modelSelected((name: String, id: Int, filterType: SearchPhotoFilterType, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, filter in
      guard let self else { return }
      if index.row == 0 { self.listener?.updateFilter(cateogryList: [], moodList: [], colorList: [])}
      else {
        var filterList = self.listener?.selectedFilter.value ?? []
        filterList.remove(at: index.row)
        
        if filterList.count == 1 { self.listener?.updateFilter(cateogryList: [], moodList: [], colorList: [])}
        else {
          var filterList = self.listener?.selectedFilter.value ?? []
          filterList.remove(at: index.row)
          let categoryList = filterList.filter{$0.filterType == .Board}
          let moodList = filterList.filter{$0.filterType == .Mood}
          let colorList = filterList.filter{$0.filterType == .Color}
          
          self.listener?.updateFilter(cateogryList: categoryList, moodList: moodList, colorList: colorList)
        }
      }
      
    }).disposed(by: disposeBag)
  }
}
