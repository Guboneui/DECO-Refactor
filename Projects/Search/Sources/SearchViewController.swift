//
//  SearchViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import UIKit

import Util
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol SearchPresentableListener: AnyObject {
  
  var searchHistory: BehaviorRelay<[String]> { get }
  
  func searchText(with keyword: String)
  func removeAllSearchHistory()
  func popSearchVC(with popType: PopType)
  func pushSearchResultVC(with searchText: String)
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
  
  weak var listener: SearchPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: true
  )
  
  private let searchBarView: UIView = UIView().then {
    $0.makeCornerRadius(radius: 10)
    $0.backgroundColor = .DecoColor.lightGray1
  }
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.searchGray2
  }
  
  private let searchTextField: UITextField = UITextField().then {
    $0.placeholder = "브랜드 및 상품 검색하기"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
    $0.textColor = .DecoColor.darkGray2
    $0.returnKeyType = .search
    $0.setClearButton(with: .DecoImage.closeFill, mode: .whileEditing)
  }
  
  private let recentSearchTextLabel: UILabel = UILabel().then {
    $0.text = "최근 검색어"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.gray4
  }
  
  private let removeSearchHistoryButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.tintColor = .DecoColor.gray3
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 10)
    $0.backgroundColor = .DecoColor.lightBackground
    $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    $0.makeCornerRadius(radius: 8)
  }
  
  private let recentSearchListCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
    $0.showsHorizontalScrollIndicator = false
    $0.setupSelectionFilterLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBindings()
    self.setupCollectionViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.searchTextField.becomeFirstResponder()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popSearchVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.navigationBar.addSubview(searchBarView)
    self.searchBarView.addSubview(searchImageView)
    self.searchBarView.addSubview(searchTextField)
    self.view.addSubview(recentSearchTextLabel)
    self.view.addSubview(removeSearchHistoryButton)
    self.view.addSubview(recentSearchListCollectionView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    searchBarView.pin
      .vCenter()
      .left(68)
      .right(24)
      .height(32)
    
    searchImageView.pin
      .left(20)
      .vertically(6)
      .size(20)
    
    searchTextField.pin
      .left(to: searchImageView.edge.right)
      .right(10)
      .vCenter()
      .marginLeft(20)
      .height(20)
    
    recentSearchTextLabel.pin
      .below(of: navigationBar)
      .left(22)
      .marginTop(30)
      .sizeToFit()
      
    removeSearchHistoryButton.pin
      .vCenter(to: recentSearchTextLabel.edge.vCenter)
      .right(11)
      .sizeToFit()
    
    recentSearchListCollectionView.pin
      .below(of: recentSearchTextLabel)
      .horizontally()
      .height(30)
      .marginTop(15)
  }
  
  private func setupGestures() {
    navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popSearchVC(with: .BackButton)
    }
    
    removeSearchHistoryButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.removeAllSearchHistory()
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    searchTextField.rx.controlEvent(.editingDidEndOnExit)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        if let text = self.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !text.isEmpty {
          self.listener?.searchText(with: text)
          self.listener?.pushSearchResultVC(with: text)
        }
      }).disposed(by: disposeBag)
  }
  
  private func setupCollectionViews() {
    listener?.searchHistory
      .bind(to: recentSearchListCollectionView.rx.items(
        cellIdentifier: FilterCell.identifier,
        cellType: FilterCell.self)
      ) { index, searchText, cell in
        cell.setupCellDefaultConfigure(text: searchText)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      recentSearchListCollectionView.rx.itemSelected,
      recentSearchListCollectionView.rx.modelSelected(String.self)
    ).subscribe(onNext: { [weak self] index, searchText in
      guard let self else { return }
      self.listener?.searchText(with: searchText)
      self.listener?.pushSearchResultVC(with: searchText)
    }).disposed(by: disposeBag)
  }
  
  func searchHistoryIsEmpty(isEmpty: Bool) {
    recentSearchTextLabel.isHidden = isEmpty
    removeSearchHistoryButton.isHidden = isEmpty
    recentSearchListCollectionView.isHidden = isEmpty
  }
}
