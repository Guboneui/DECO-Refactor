//
//  FollowViewController.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import Util
import UIKit

import CommonUI

import RIBs
import RxSwift
import RxRelay
import PinLayout
import FlexLayout

protocol FollowPresentableListener: AnyObject {
  var followVCs: BehaviorRelay<[ViewControllable]> { get }
  var currentFollowTab: BehaviorRelay<FollowTabType> { get }
  
  func popFollowVC(with popType: PopType)
}

final class FollowViewController: UIViewController, FollowPresentable, FollowViewControllable {
  
  weak var listener: FollowPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  private var onlyOnceCollectionViewWillDisplay: Bool = false
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: false
  )
  
  private let segmentContainerView: UIView = UIView()
  
  private let followerButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("팔로워")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.titleLabel?.textAlignment = .center
    $0.tintColor = .DecoColor.gray1
  }
  
  private let followingButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("팔로잉")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.titleLabel?.textAlignment = .center
    $0.tintColor = .DecoColor.gray1
  }
  
  private let segmentContainerGuideLineView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.lightGray2
  }
  
  private let segmentBar: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor
  }
  
  private let segmentBarWidth: CGFloat = UIScreen.main.bounds.width / 2.0
  private let segmentBarDuration: TimeInterval = 0.75
  private let segmentBarDelay: TimeInterval = 0.0
  private let segmentBarSpringValue: CGFloat = 1.0
  private let segmentBarAnimateOption: UIView.AnimationOptions = .curveEaseOut
  
  private let followCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
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
    self.setupFollowCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popFollowVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(segmentContainerView)
    self.view.addSubview(segmentContainerGuideLineView)
    self.view.addSubview(segmentBar)
    self.view.addSubview(followCollectionView)
    
    segmentContainerView.flex.direction(.row).define { flex in
      flex.addItem(followerButton).grow(1)
      flex.addItem(followingButton).grow(1)
    }
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    segmentContainerView.pin
      .below(of: navigationBar)
      .horizontally()
      .height(35)
      .marginTop(13)
    
    segmentContainerGuideLineView.pin
      .below(of: segmentContainerView)
      .horizontally()
      .height(1)
    
    segmentBar.pin
      .below(of: segmentContainerView)
      .left()
      .width(segmentBarWidth)
      .height(1)
    
    followCollectionView.pin
      .below(of: segmentContainerView)
      .horizontally()
      .bottom()
      .marginTop(20)
    
    segmentContainerView.flex.layout()
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popFollowVC(with: .BackButton)
    }
    
    followerButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentFollowTab.accept(.Follower)
        self.moveSegmentCollectionView(.Follower)
      }.disposed(by: disposeBag)
    
    followingButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.currentFollowTab.accept(.Following)
        self.moveSegmentCollectionView(.Following)
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    self.listener?.currentFollowTab
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] currentTab in
        guard let self else { return }
        self.setSelectedTabState(currentTab)
      }).disposed(by: disposeBag)
  }
  
  private func setupFollowCollectionView() {
    listener?.followVCs
      .bind(to: followCollectionView.rx.items(
        cellIdentifier: ChildViewCell.identifier,
        cellType: ChildViewCell.self)
      ) { [weak self] (index, childViewControllerable, cell) in
        guard let self else { return }
        self.addChild(childViewControllerable.uiviewController)
        childViewControllerable.uiviewController.didMove(toParent: self)
        cell.setupCellConfigure(childVC: childViewControllerable.uiviewController)
      }.disposed(by: disposeBag)
    
    followCollectionView.rx.contentOffset
      .observe(on: MainScheduler.instance)
      .map{$0.x}
      .bind { [weak self] currentXOffset in
        guard let self else { return }
        self.moveSegmentBarWithScrollOffset(offset: currentXOffset / 2.0)
        
        let scrollViewContentOffset: CGFloat = UIScreen.main.bounds.width
        if currentXOffset == 0.0 { self.listener?.currentFollowTab.accept(.Follower) }
        if currentXOffset == scrollViewContentOffset { self.listener?.currentFollowTab.accept(.Following) }
      }.disposed(by: disposeBag)
    
    followCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  func setNavTitle(with title: String) {
    self.navigationBar.setNavigationBarTitle(with: title)
  }
  
  func setFirstFollowStatus(with tabType: FollowTabType) {
    followCollectionView.rx.willDisplayCell
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        if !self.onlyOnceCollectionViewWillDisplay {
          switch tabType {
          case .Following:
            self.followCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: false)
          default:
            break
          }
        }
        self.onlyOnceCollectionViewWillDisplay = true
      }).disposed(by: disposeBag)
  }
}

extension FollowViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: followCollectionView.frame.width,
      height: followCollectionView.frame.height
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

extension FollowViewController {
  
  private func moveSegmentCollectionView(_ currentTab: FollowTabType) {
    switch currentTab {
    case .Follower:
      self.followCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    case .Following:
      self.followCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: true)
    }
  }
  
  private func moveSegmentBarWithScrollOffset(offset: CGFloat) {
    segmentBar.pin
      .below(of: segmentContainerView)
      .left()
      .width(segmentBarWidth)
      .height(1)
      .marginLeft(offset)
  }
  
  private func setSelectedTabState(_ currentTab: FollowTabType) {
    switch currentTab {
    case .Follower:
      self.followerButton.tintColor = .DecoColor.darkGray2
      self.followingButton.tintColor = .DecoColor.gray1
      
    case .Following:
      self.followerButton.tintColor = .DecoColor.gray1
      self.followingButton.tintColor = .DecoColor.darkGray2
    }
  }
}
