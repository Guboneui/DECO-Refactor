//
//  BookmarkViewController.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import UIKit

import CommonUI

import RIBs
import RxSwift
import RxRelay
import PinLayout
import FlexLayout

protocol BookmarkPresentableListener: AnyObject {
  var currentSegmentTab: BehaviorRelay<BookMarkSegmentType> { get }
  var bookmarkVCs: BehaviorRelay<[ViewControllable]> { get }
}

final class BookmarkViewController: UIViewController, BookmarkPresentable, BookmarkViewControllable {
  
  weak var listener: BookmarkPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "나의 저장 목록"
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textColor = .DecoColor.darkGray1
  }
  
  private let segmentContainerView: UIView = UIView()
  
  private let photoButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("사진")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    $0.titleLabel?.textAlignment = .center
    $0.tintColor = .DecoColor.secondaryColor
  }
  
  private let productButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("상품")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    $0.titleLabel?.textAlignment = .center
    $0.tintColor = .DecoColor.secondaryColor
  }
  
  private let segmentBar: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.secondaryColor
  }
  
  private let segmentBarWidth: CGFloat = UIScreen.main.bounds.width / 2.0
  private let segmentBarDuration: TimeInterval = 0.75
  private let segmentBarDelay: TimeInterval = 0.0
  private let segmentBarSpringValue: CGFloat = 1.0
  private let segmentBarAnimateOption: UIView.AnimationOptions = .curveEaseOut
  
  private let segmentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
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
    self.setupSegmentCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(titleLabel)
    self.view.addSubview(segmentContainerView)
    self.view.addSubview(segmentBar)
    self.view.addSubview(segmentCollectionView)
    
    segmentContainerView.flex.direction(.row).define { flex in
      flex.addItem(photoButton).grow(1)
      flex.addItem(productButton).grow(1)
    }
  }
  
  private func setupLayouts() {
    titleLabel.pin
      .top(view.pin.safeArea.top)
      .horizontally(28)
      .marginTop(10)
      .height(24)
    
    segmentContainerView.pin
      .below(of: titleLabel)
      .horizontally()
      .height(24)
      .marginTop(24)
    
    segmentBar.pin
      .below(of: segmentContainerView)
      .left()
      .width(segmentBarWidth)
      .height(1)
      .marginTop(0.25)
    
    segmentCollectionView.pin
      .below(of: segmentContainerView)
      .horizontally()
      .bottom()
      .marginTop(16)
    
    segmentContainerView.flex.layout()
  }
  
  private func setupGestures() {
    photoButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentSegmentTab.accept(.Photo)
        self.moveSegmentCollectionView(.Photo)
      }.disposed(by: disposeBag)
    
    productButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentSegmentTab.accept(.Product)
        self.moveSegmentCollectionView(.Product)
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    self.listener?.currentSegmentTab
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] currentTab in
        guard let self else { return }
        self.setSelectedTabState(currentTab)
      }).disposed(by: disposeBag)
  }
  
  private func setupSegmentCollectionView() {
    listener?.bookmarkVCs
      .bind(to: segmentCollectionView.rx.items(
        cellIdentifier: ChildViewCell.identifier,
        cellType: ChildViewCell.self)
      ) { [weak self] (index, childViewControllerable, cell) in
        guard let self else { return }
        self.addChild(childViewControllerable.uiviewController)
        childViewControllerable.uiviewController.didMove(toParent: self)
        cell.setupCellConfigure(childVC: childViewControllerable.uiviewController)
      }.disposed(by: disposeBag)
    
    segmentCollectionView.rx.contentOffset
      .observe(on: MainScheduler.instance)
      .map{$0.x}
      .bind { [weak self] currentXOffset in
        guard let self else { return }
        self.moveSegmentBarWithScrollOffset(offset: currentXOffset / 2.0)
        
        let scrollViewContentOffset: CGFloat = UIScreen.main.bounds.width
        if currentXOffset == 0.0 { self.listener?.currentSegmentTab.accept(.Photo) }
        if currentXOffset == scrollViewContentOffset { self.listener?.currentSegmentTab.accept(.Product) }
      }.disposed(by: disposeBag)
    
    segmentCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}



// MARK: - SegmentBar Animation
extension BookmarkViewController {
  
  private func moveSegmentCollectionView(_ currentTab: BookMarkSegmentType) {
    switch currentTab {
    case .Photo:
      self.segmentCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    case .Product:
      self.segmentCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: true)
    }
  }
  
  private func moveSegmentBarWithScrollOffset(offset: CGFloat) {
    segmentBar.pin
      .below(of: segmentContainerView)
      .left()
      .width(segmentBarWidth)
      .height(1)
      .marginTop(0.25)
      .marginLeft(offset)
  }
  
  private func setSelectedTabState(_ currentTab: BookMarkSegmentType) {
    switch currentTab {
    case .Photo:
      self.photoButton.tintColor = .DecoColor.secondaryColor
      self.photoButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
      
      self.productButton.tintColor = .DecoColor.gray1
      self.productButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
      
    case .Product:
      self.photoButton.tintColor = .DecoColor.gray1
      self.photoButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
      
      self.productButton.tintColor = .DecoColor.secondaryColor
      self.productButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    }
  }
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: segmentCollectionView.frame.width,
      height: segmentCollectionView.frame.height
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
