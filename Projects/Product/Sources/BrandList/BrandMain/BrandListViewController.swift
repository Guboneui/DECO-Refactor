//
//  BrandListViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import UIKit

import RIBs
import RxSwift
import RxCocoa
import RxRelay

import Entity

protocol BrandListPresentableListener: AnyObject {
  func pushBrandDetailVC(brandInfo: BrandDTO)
  
  var brandList: BehaviorRelay<[BrandDTO]> { get }
}

final class BrandListViewController: UIViewController, BrandListPresentable, BrandListViewControllable {
  
  weak var listener: BrandListPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    
    $0.register(BrandListCell.self, forCellWithReuseIdentifier: BrandListCell.identifier)
    $0.showsVerticalScrollIndicator = false
    $0.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 36, right: 0)
    
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
    
    $0.setupDefaultListLayout(cellHeight: 24, groupSpacing: 36.0)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupBrandListCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(collectionView)
  }
  
  private func setupLayouts() {
    self.collectionView.pin.all()
  }
  
  private func setupBrandListCollectionView() {
    collectionView.delegate = nil
    collectionView.dataSource = nil
    
    listener?.brandList
      .bind(to: collectionView.rx.items(
        cellIdentifier: BrandListCell.identifier,
        cellType: BrandListCell.self)
      ) { (index, data, cell) in
        cell.setCellConfigure(text: data.name)
      }.disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected(BrandDTO.self)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.pushBrandDetailVC(brandInfo: $0)
        print("\($0)")
      })
      .disposed(by: disposeBag)
  }
}
