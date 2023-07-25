//
//  CommentViewController.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import UIKit
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay


protocol CommentPresentableListener: AnyObject {
  var commentList: BehaviorRelay<[CommentDTO]> { get }
  func fetchCommentListNextPage(at createdAt: Int)
  func pushCommentDetailVC(at index: Int)
}

final class CommentViewController: UIViewController, CommentPresentable, CommentViewControllable {
  
  weak var listener: CommentPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let inputField: UIView = UIView().then {
    $0.backgroundColor = .blue
  }
  
  private let commentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupCommentListLayout()
    $0.showsVerticalScrollIndicator = false
    $0.bounces = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupCollectionView()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(inputField)
    self.view.addSubview(commentCollectionView)
  }
  
  private func setupLayouts() {
    
    inputField.pin
      .horizontally()
      .bottom()
      .height(70)
    
    commentCollectionView.pin
      .above(of: inputField)
      .top()
      .horizontally()
  }
  
  private func setupCollectionView() {
    commentCollectionView.delegate = nil
    commentCollectionView.dataSource = nil
    
    listener?.commentList
      .bind(to: commentCollectionView.rx.items(
        cellIdentifier: CommentCell.identifier,
        cellType: CommentCell.self)
      ) { index, comment, cell in
        cell.setupCellConfigure(
          profileUrl: comment.profileUrl,
          userName: comment.nickname,
          comment: comment.postingReply.reply,
          createdAt: comment.postingReply.createdAt,
          childReplyCount: comment.replyCount,
          commentType: .Parent
        )
      }.disposed(by: disposeBag)
    
    commentCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let commentList = self.listener?.commentList.value,
           commentList.count - 1 == index {
          let lastCreatedAt = commentList[index].postingReply.createdAt
          self.listener?.fetchCommentListNextPage(at: lastCreatedAt)
        }
        
      }).disposed(by: disposeBag)
    
    
    commentCollectionView.rx.itemSelected
      .map{$0.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        self.listener?.pushCommentDetailVC(at: index)
      }).disposed(by: disposeBag)
  }
}
