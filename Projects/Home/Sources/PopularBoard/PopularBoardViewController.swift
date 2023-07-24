//
//  PopularBoardViewController.swift
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

protocol PopularBoardPresentableListener: AnyObject {
  var popularBoardList: BehaviorRelay<[PostingDTO]> { get }
  
  func fetchPopularBoardList(at createdAt: Int)
  func pushHomeBoardFeedVC(at startIndex: Int, type: HomeType)
}

final class PopularBoardViewController: UIViewController, PopularBoardPresentable, PopularBoardViewControllable {
  
  weak var listener: PopularBoardPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let emptyNoticeLabel: UILabel = UILabel().then {
    $0.text = "인기 게시물이 없어요"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let popularBoardCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
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
    self.setupPopularBoardCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(emptyNoticeLabel)
    self.view.addSubview(popularBoardCollectionView)
  }
  
  private func setupLayouts() {
    
    emptyNoticeLabel.pin
      .center()
      .sizeToFit()
    
    popularBoardCollectionView.pin.all()
  }
  
  private func setupPopularBoardCollectionView() {
    popularBoardCollectionView.delegate = nil
    popularBoardCollectionView.dataSource = nil
    
    listener?.popularBoardList
      .share()
      .observe(on: MainScheduler.instance)
      .bind { [weak self] in
        guard let self else { return }
        self.popularBoardCollectionView.isHidden = $0.isEmpty
        self.emptyNoticeLabel.isHidden = !$0.isEmpty
      }.disposed(by: disposeBag)
    
    listener?.popularBoardList
      .share()
      .bind(to: popularBoardCollectionView.rx.items(
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
      popularBoardCollectionView.rx.itemSelected,
      popularBoardCollectionView.rx.modelSelected(PostingDTO.self)
    ).subscribe(onNext: { [weak self] index, model in
      guard let self else { return }
      self.listener?.pushHomeBoardFeedVC(at: index.row, type: .Popular)
    }).disposed(by: disposeBag)
    
    popularBoardCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let boardList = self.listener?.popularBoardList.value,
           boardList.count - 1 == index {
          let lastCreatedAt = boardList[index].createdAt ?? Int.max
          self.listener?.fetchPopularBoardList(at: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
  }
}
