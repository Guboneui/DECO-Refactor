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
}

final class PopularBoardViewController: UIViewController, PopularBoardPresentable, PopularBoardViewControllable {
  
  weak var listener: PopularBoardPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let popularBoardCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.setupDefaultTwoColumnGridLayout()
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
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
    self.view.addSubview(popularBoardCollectionView)
  }
  
  private func setupLayouts() {
    popularBoardCollectionView.pin.all()
  }
  
  private func setupPopularBoardCollectionView() {
    popularBoardCollectionView.delegate = nil
    popularBoardCollectionView.dataSource = nil
    
    listener?.popularBoardList
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
