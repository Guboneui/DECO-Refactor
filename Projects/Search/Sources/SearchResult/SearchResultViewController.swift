//
//  SearchResultViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import UIKit

import Util
import CommonUI

import RIBs
import RxSwift
import RxRelay
import FlexLayout

protocol SearchResultPresentableListener: AnyObject {
  
  var currentTab: BehaviorRelay<SearchTab> { get }
  var childVCs: BehaviorRelay<[ViewControllable]> { get }
  
  func popSearchResultVC(with popType: PopType)
}

final class SearchResultViewController: UIViewController, SearchResultPresentable, SearchResultViewControllable {
  
  weak var listener: SearchResultPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: false
  )
  
  private let searchBarView: UIView = UIView().then {
    $0.makeCornerRadius(radius: 10)
    $0.backgroundColor = .DecoColor.lightGray1
  }
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.searchGray2
  }
  
  private let searchTextLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let photoButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("사진")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  private let productButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("상품")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  private let brandButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("브랜드")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  private let userButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("유저")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  private let tabbarContainer: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let tabbarGuideLineView = UIView().then {
    $0.backgroundColor = .DecoColor.lightGray2
  }
  
  private let tabSegmentBar: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.darkGray2
  }
  
  private let segmentBarWidth: CGFloat = UIScreen.main.bounds.width / 4.0
  
  private let mainCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.kakaoColor
    $0.register(ChildViewCell.self, forCellWithReuseIdentifier: ChildViewCell.identifier)
    $0.bounces = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBindings()
    self.setupMainCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popSearchResultVC(with: .Swipe)
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
    self.searchBarView.addSubview(searchTextLabel)
    self.view.addSubview(tabbarContainer)
    self.view.addSubview(tabbarGuideLineView)
    self.view.addSubview(tabSegmentBar)
    self.view.addSubview(mainCollectionView)
    
    tabbarContainer.flex.direction(.row).define { flex in
      flex.addItem(photoButton).grow(1)
      flex.addItem(productButton).grow(1)
      flex.addItem(brandButton).grow(1)
      flex.addItem(userButton).grow(1)
    }
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
    
    searchTextLabel.pin
      .left(to: searchImageView.edge.right)
      .right(10)
      .vCenter()
      .marginLeft(20)
      .sizeToFit()
    
    tabbarContainer.pin
      .below(of: navigationBar)
      .horizontally()
      .height(24)
      .marginTop(24)
    
    tabbarGuideLineView.pin
      .below(of: tabbarContainer)
      .horizontally()
      .marginTop(0.25)
      .height(0.5)
    
    tabSegmentBar.pin
      .vCenter(to: tabbarGuideLineView.edge.vCenter)
      .horizontally()
      .height(1)
      .width(segmentBarWidth)
    
    mainCollectionView.pin
      .below(of: tabbarContainer)
      .horizontally()
      .bottom()
      .marginTop(1)
    
    tabbarContainer.flex.layout()
  }
  
  private func setupGestures() {
    navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popSearchResultVC(with: .BackButton)
    }
    
    searchBarView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.popSearchResultVC(with: .BackButton)
      }.disposed(by: disposeBag)
    
    photoButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentTab.accept(.Photo)
        self.moveSegmentCollectionView(.Photo)
      }.disposed(by: disposeBag)
    
    productButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentTab.accept(.Product)
        self.moveSegmentCollectionView(.Product)
      }.disposed(by: disposeBag)
    
    brandButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentTab.accept(.Brand)
        self.moveSegmentCollectionView(.Brand)
      }.disposed(by: disposeBag)
    
    userButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentTab.accept(.User)
        self.moveSegmentCollectionView(.User)
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    listener?.currentTab
      .compactMap{$0}
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] currentTab in
        guard let self else { return }
        self.setCurrentTabState(with: currentTab)
      }).disposed(by: disposeBag)
  }
  
  
  private func setupMainCollectionView() {
    mainCollectionView.delegate = nil
    mainCollectionView.dataSource = nil
    
    listener?.childVCs
      .bind(to: mainCollectionView.rx.items(
        cellIdentifier: ChildViewCell.identifier,
        cellType: ChildViewCell.self)
      ) { [weak self] index, childVC, cell in
        guard let self else { return }
        self.addChild(childVC.uiviewController)
        childVC.uiviewController.didMove(toParent: self)
        cell.setupCellConfigure(childVC: childVC.uiviewController)
      }.disposed(by: disposeBag)
    
    
    mainCollectionView.rx.contentOffset
      .observe(on: MainScheduler.instance)
      .map{$0.x}
      .bind { [weak self] currentXOffset in
        guard let self else { return }
        self.moveSegmentBarWithScrollOffset(offset: currentXOffset / 4.0)
        
        let scrollViewContentOffset: CGFloat = UIScreen.main.bounds.width
        
        if currentXOffset == 0.0 { self.listener?.currentTab.accept(.Photo) }
        else if currentXOffset == scrollViewContentOffset * 1.0 { self.listener?.currentTab.accept(.Product) }
        else if currentXOffset == scrollViewContentOffset * 2.0 { self.listener?.currentTab.accept(.Brand) }
        else if currentXOffset == scrollViewContentOffset * 3.0 { self.listener?.currentTab.accept(.User) }
      }.disposed(by: disposeBag)
    
    
    mainCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  // MARK: - SearchResultPresentable
  func setSearchTextLabel(with searchText: String) {
    self.searchTextLabel.text = searchText
    self.searchTextLabel.pin.sizeToFit()
  }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: mainCollectionView.frame.width,
      height: mainCollectionView.frame.height
    )
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
}

extension SearchResultViewController {
  private func moveSegmentCollectionView(_ currentTab: SearchTab) {
    switch currentTab {
    case .Photo:
      self.mainCollectionView.scrollToItem(
        at: IndexPath(row: 0, section: 0),
        at: .left,
        animated: true
      )
    case .Product:
      self.mainCollectionView.scrollToItem(
        at: IndexPath(row: 1, section: 0),
        at: .left,
        animated: true
      )
    case .Brand:
      self.mainCollectionView.scrollToItem(
        at: IndexPath(row: 2, section: 0),
        at: .left,
        animated: true
      )
    case .User:
      self.mainCollectionView.scrollToItem(
        at: IndexPath(row: 3, section: 0),
        at: .left,
        animated: true
      )
    }
  }
  
  private func moveSegmentBarWithScrollOffset(offset: CGFloat) {
    self.tabSegmentBar.pin
      .vCenter(to: tabbarGuideLineView.edge.vCenter)
      .left()
      .height(1)
      .width(segmentBarWidth)
      .marginLeft(offset)
  }
  
  private func setCurrentTabState(with currentTab: SearchTab) {
    photoButton.tintColor = currentTab == .Photo ? .DecoColor.darkGray2 : .DecoColor.gray1
    productButton.tintColor = currentTab == .Product ? .DecoColor.darkGray2 : .DecoColor.gray1
    brandButton.tintColor = currentTab == .Brand ? .DecoColor.darkGray2 : .DecoColor.gray1
    userButton.tintColor = currentTab == .User ? .DecoColor.darkGray2 : .DecoColor.gray1
  }
}
