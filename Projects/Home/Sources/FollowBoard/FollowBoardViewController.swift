//
//  FollowBoardViewController.swift
//  Home
//
//  Created by 구본의 on 2023/07/03.
//

import UIKit

import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
protocol FollowBoardPresentableListener: AnyObject {
  var followBoardList: BehaviorRelay<[PostingDTO]> { get }
  
  func fetchFollowBoardList(at createdAt: Int)
}

final class FollowBoardViewController: UIViewController, FollowBoardPresentable, FollowBoardViewControllable {
  
  weak var listener: FollowBoardPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let emptyNoticeLabel: UILabel = UILabel().then {
    $0.text = "다른 유저를 팔로우해주세요!"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let followBoardCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupDefaultTwoColumnGridLayout()
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
    $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupFollowBoardCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(emptyNoticeLabel)
    self.view.addSubview(followBoardCollectionView)
  }
  
  private func setupLayouts() {
    
    emptyNoticeLabel.pin
      .center()
      .sizeToFit()
    
    followBoardCollectionView.pin.all()
  }
  
  private func setupFollowBoardCollectionView() {
    followBoardCollectionView.delegate = nil
    followBoardCollectionView.dataSource = nil
    
    listener?.followBoardList
      .share()
      .observe(on: MainScheduler.instance)
      .bind { [weak self] in
        guard let self else { return }
        self.followBoardCollectionView.isHidden = $0.isEmpty
        self.emptyNoticeLabel.isHidden = !$0.isEmpty
      }.disposed(by: disposeBag)
    
    listener?.followBoardList
      .share()
      .bind(to: followBoardCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { [weak self] index, data, cell in
        guard let self else { return }
        cell.setupCellConfigure(
          type: .DefaultType,
          imageURL: data.imageUrl ?? ""
        )
      }.disposed(by: disposeBag)
    
    followBoardCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let boardList = self.listener?.followBoardList.value,
           boardList.count - 1 == index {
          let lastCreatedAt = boardList[index].createdAt ?? Int.max
          self.listener?.fetchFollowBoardList(at: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
  }
}
