//
//  HomeBoardFeedViewController.swift
//  Home
//
//  Created by 구본의 on 2023/07/25.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol HomeBoardFeedPresentableListener: AnyObject {
  var boardList: BehaviorRelay<[PostingDTO]> { get }
  
  func popHomeBoardFeedVC(with popType: PopType)
  func pushTargetUserProfileVC(at index: Int)
  func presentCommentBaseVC(at index: Int)
  func fetchBoardBookmark(at index: Int)
  func fetchBoardLike(at index: Int)
  func checkCurrentBoardUser(at index: Int)
  func fetchBoardList(lastIndex index: Int)
  func fetchDeleteBoard(at index: Int)
  
  func pushProductDetailVC(with productID: Int)
}

final class HomeBoardFeedViewController: UIViewController, HomeBoardFeedPresentable, HomeBoardFeedViewControllable {
  
  weak var listener: HomeBoardFeedPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: FeedNavigationBar = FeedNavigationBar()
  private let feedCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .black
    $0.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
    $0.bounces = false
    $0.alwaysBounceHorizontal = false
    $0.showsHorizontalScrollIndicator = false
    $0.isPagingEnabled = true
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
      listener?.popHomeBoardFeedVC(with: .Swipe)
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
    
    feedCollectionView.feedLayout()
  }
  
  func setupGestures() {
    self.navigationBar.didTapBackButtonAction = { [weak self] in
      guard let self else { return }
      self.listener?.popHomeBoardFeedVC(with: .BackButton)
    }
    
    self.view.rx.swipeGesture(.up)
      .when(.recognized)
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.popHomeBoardFeedVC(with: .BackButton)
      }.disposed(by: disposeBag)
    
    self.navigationBar.didTapOptionButtonAction = { [weak self] in
      guard let self else { return }
      let currentIndex: Int = self.feedCollectionView.currentIndex
      self.listener?.checkCurrentBoardUser(at: currentIndex)
    }
  }
  
  private func setupCollectionView() {
    feedCollectionView.delegate = nil
    feedCollectionView.dataSource = nil
    
    listener?.boardList
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
          let currentIndex: Int = inSelf.feedCollectionView.currentIndex
          inSelf.listener?.presentCommentBaseVC(at: currentIndex)
          print("Clicked Comment Button ")
        }
        
        cell.didTapBookmarkButton = { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.fetchBoardBookmark(at: index)
        }
        
        cell.didTapProductSticker = { [weak self] productID in
          guard let inSelf = self else { return }
          inSelf.listener?.pushProductDetailVC(with: productID)
        }
        
        cell.didTapBrandSticker = { [weak self] brandName in
          guard let inSelf = self else { return }
          let popup = BrandStickerPopupView(brandName: brandName)
          popup.modalPresentationStyle = .overFullScreen
          inSelf.present(popup, animated: false, completion: nil)
        }
      }.disposed(by: disposeBag)
    
    feedCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .share()
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let boardList = self.listener?.boardList.value,
           boardList.count - 1 == index {
          self.listener?.fetchBoardList(lastIndex: index)
        }
        
      }).disposed(by: disposeBag)
  }
  
  func moveToStartIndex(at index: Int) {
    feedCollectionView.rx.willDisplayCell
      .take(1)
      .share()
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        let startIndexPath: IndexPath = IndexPath(row: index, section: 0)
        self.feedCollectionView.scrollToItem(
          at: startIndexPath,
          at: .right,
          animated: false
        )
      }).disposed(by: disposeBag)
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
    ) { [weak self] _ in
      guard let self else { return }
      let currentIndex: Int = self.feedCollectionView.currentIndex
      self.listener?.fetchDeleteBoard(at: currentIndex)
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
