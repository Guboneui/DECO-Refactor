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
  
  private let followBoardCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupDefaultTwoColumnGridLayout()
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
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
    self.view.addSubview(followBoardCollectionView)
  }
  
  private func setupLayouts() {
    followBoardCollectionView.pin.all()
  }
  
  private func setupFollowBoardCollectionView() {
    followBoardCollectionView.delegate = nil
    followBoardCollectionView.dataSource = nil
    
    listener?.followBoardList
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
