//
//  LatestBoardViewController.swift
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

protocol LatestBoardPresentableListener: AnyObject {
  var latestBoardList: BehaviorRelay<[PostingDTO]> { get }
  
  func fetchLatestBoardList(at createdAt: Int)
  func pushLatestBoardFeedVC(at startIndex: Int)
}

final class LatestBoardViewController: UIViewController, LatestBoardPresentable, LatestBoardViewControllable {
  
  weak var listener: LatestBoardPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let latestBoardCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupDefaultTwoColumnGridLayout()
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupLastestBoardCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(latestBoardCollectionView)
  }
  
  private func setupLayouts() {
    latestBoardCollectionView.pin.all()
  }
  
  private func setupLastestBoardCollectionView() {
    latestBoardCollectionView.delegate = nil
    latestBoardCollectionView.dataSource = nil
    
    listener?.latestBoardList
      .bind(to: latestBoardCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { [weak self] index, data, cell in
        guard let self else { return }
        cell.setupCellConfigure(
          type: .DefaultType,
          imageURL: data.imageUrl ?? ""
        )
      }.disposed(by: disposeBag)
    
    Observable.zip(
      latestBoardCollectionView.rx.itemSelected,
      latestBoardCollectionView.rx.modelSelected(PostingDTO.self)
    ).subscribe(onNext: { [weak self] index, model in
      guard let self else { return }
      self.listener?.pushLatestBoardFeedVC(at: index.row)
    }).disposed(by: disposeBag)
    
    latestBoardCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let boardList = self.listener?.latestBoardList.value,
           boardList.count - 1 == index {
          let lastCreatedAt = boardList[index].createdAt ?? Int.max
          self.listener?.fetchLatestBoardList(at: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
  }
}
