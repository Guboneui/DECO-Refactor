//
//  CommentDetailViewController.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol CommentDetailPresentableListener: AnyObject {
  var childCommentList: BehaviorRelay<[CommentDTO]> { get }
  
  func didTapCloseButton()
  func popCommentDetailVC(with popType: PopType)
  func fetchChildCommentListNextPage(at createdAt: Int)
}

final class CommentDetailViewController: UIViewController, CommentDetailPresentable, CommentDetailViewControllable {
  
  weak var listener: CommentDetailPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(navTitle: "댓글", showGuideLine: true)
  private let closeButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.close, for: .normal)
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .DecoColor.gray4
  }
  
  private let inputField: UIView = UIView().then {
    $0.backgroundColor = .blue
  }
  
  private let commentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupCommentListLayout(inset: 0)
    $0.showsVerticalScrollIndicator = false
    $0.bounces = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popCommentDetailVC(with: .Swipe)
    }
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.navigationBar.addSubview(closeButton)
    self.view.addSubview(inputField)
    self.view.addSubview(commentCollectionView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top()
      .horizontally()
      .sizeToFit(.width)
    
    closeButton.pin
      .vCenter()
      .size(18)
      .right(16)
    
    inputField.pin
      .horizontally()
      .bottom()
      .height(70)
    
    commentCollectionView.pin
      .below(of: navigationBar)
      .above(of: inputField)
      .horizontally()
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popCommentDetailVC(with: .BackButton)
    }
    
    self.closeButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.didTapCloseButton()
      }.disposed(by: disposeBag)
  }
  
  private func setupCollectionView() {
    commentCollectionView.delegate = nil
    commentCollectionView.dataSource = nil
    
    listener?.childCommentList
      .bind(to: commentCollectionView.rx.items(
        cellIdentifier: CommentCell.identifier,
        cellType: CommentCell.self)
      ) { index, comment, cell in
        
        
        if index == 0 {
          cell.setupCellConfigure(
            profileUrl: comment.profileUrl,
            userName: comment.nickname,
            comment: comment.postingReply.reply,
            createdAt: comment.postingReply.createdAt,
            childReplyCount: comment.replyCount,
            commentType: .ParentInChild
          )
        } else {
          cell.setupCellConfigure(
            profileUrl: comment.profileUrl,
            userName: comment.nickname,
            comment: comment.postingReply.reply,
            createdAt: comment.postingReply.createdAt,
            childReplyCount: comment.replyCount,
            commentType: .Child
          )
        }
        

        
      }.disposed(by: disposeBag)
    
    commentCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let commentList = self.listener?.childCommentList.value,
           commentList.count - 1 == index {
          let lastCreatedAt = commentList[index].postingReply.createdAt
          self.listener?.fetchChildCommentListNextPage(at: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
  }
}
