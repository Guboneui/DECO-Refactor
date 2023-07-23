//
//  LatestBoardFeedViewController.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol LatestBoardFeedPresentableListener: AnyObject {
  var latestBoardList: BehaviorRelay<[PostingDTO]> { get }
  
  func popLatestBoardFeedVC(with popType: PopType)
  func pushTargetUserProfileVC(at index: Int)
  func fetchBoardBookmark(at index: Int)
  func fetchBoardLike(at index: Int)
  func checkCurrentBoardUser(at index: Int)
}

final class LatestBoardFeedViewController: UIViewController, LatestBoardFeedPresentable, LatestBoardFeedViewControllable {
  
  weak var listener: LatestBoardFeedPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: FeedNavigationBar = FeedNavigationBar()
  private let feedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .gray
    $0.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
    $0.bounces = false
    $0.alwaysBounceHorizontal = false
    $0.showsHorizontalScrollIndicator = false
    $0.feedLayout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    self.setupCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popLatestBoardFeedVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.backgroundColor = .black
    self.view.addSubview(navigationBar)
    self.view.addSubview(feedCollectionView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    feedCollectionView.pin
      .below(of: navigationBar)
      .horizontally()
      .bottom(view.pin.safeArea)
  }
  
  func setupGestures() {
    self.navigationBar.didTapBackButtonAction = { [weak self] in
      guard let self else { return }
      self.listener?.popLatestBoardFeedVC(with: .BackButton)
    }
    
    self.navigationBar.didTapOptionButtonAction = { [weak self] in
      guard let self else { return }
      let currentIndex: Int = self.feedCollectionView.currentIndex
      self.listener?.checkCurrentBoardUser(at: currentIndex)
    }
  }
  
  private func setupCollectionView() {
    feedCollectionView.delegate = nil
    feedCollectionView.dataSource = nil
    
    listener?.latestBoardList
      .bind(to: feedCollectionView.rx.items(
        cellIdentifier: FeedCell.identifier,
        cellType: FeedCell.self)
      ) { [weak self] index, postingData, cell in
        guard let self else { return }
        
        cell.setFeedCellConfigure(with: postingData)
        
        cell.didTapProfileImage = { [weak self] in
          guard let inSelf = self else { return }
          let currentIndex: Int = inSelf.feedCollectionView.currentIndex
          inSelf.listener?.pushTargetUserProfileVC(at: currentIndex)
        }
        
        cell.didTapLikeButton = { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.fetchBoardLike(at: index)
        }
        
        cell.didTapCommentButton = { [weak self] in
          guard let inSelf = self else { return }
          print("Clicked Comment Button ")
        }
        
        cell.didTapBookmarkButton = { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.fetchBoardBookmark(at: index)
        }
      }.disposed(by: disposeBag)
  }
  
  func showToast(status: Bool) {
    ToastManager.shared.showToast(status ? .DeleteBookmark : .AddBookmark)
  }
  
  func showAlert(isMine: Bool) {
    if isMine == true {
      self.makeMyBoardAlert()
    } else {
      self.makeOtherUserBoardAlert()
    }
  }
  
  private func makeMyBoardAlert() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let editButton = UIAlertAction(
      title: "수정하기",
      titleColor: .DecoColor.darkGray1,
      style: .default
    ) { _ in
      print("TODO: 수정하기")
    }
    
    let deleteButton = UIAlertAction(
      title: "삭제하기",
      titleColor: .DecoColor.darkGray1,
      style: .default
    ) { _ in
      print("TODO: 삭제하기")
    }
    
    let cancelButton = UIAlertAction(
      title: "취소",
      titleColor: .DecoColor.warningColor,
      style: .cancel
    )
    
    alert.addActions([editButton, deleteButton, cancelButton])
    
    self.present(alert, animated: true)
  }
  
  private func makeOtherUserBoardAlert() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let reportButton = UIAlertAction(
      title: "신고하기",
      titleColor: .DecoColor.darkGray1,
      style: .default
    ) { _ in
      print("TODO: 신고하기")
    }
    
    let cancelButton = UIAlertAction(
      title: "취소",
      titleColor: .DecoColor.warningColor,
      style: .cancel
    )
    
    alert.addActions([reportButton, cancelButton])
    
    self.present(alert, animated: true)
  }
}

