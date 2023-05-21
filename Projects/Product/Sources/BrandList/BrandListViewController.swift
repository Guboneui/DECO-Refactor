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
  var brandList: BehaviorRelay<[BrandDTO]> { get }
}

final class BrandListViewController: UIViewController, BrandListPresentable, BrandListViewControllable {
  
  weak var listener: BrandListPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    
    $0.register(BrandListCell.self, forCellWithReuseIdentifier: BrandListCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
    $0.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 36, right: 0)
    
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
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
    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    
    listener?.brandList
      .bind(to: collectionView.rx.items(
        cellIdentifier: BrandListCell.identifier,
        cellType: BrandListCell.self)
      ) { (index, data, cell) in
        cell.setCellConfigure(text: data.name)
      }.disposed(by: disposeBag)
    
    collectionView.rx
      .modelSelected(BrandDTO.self)
      .subscribe(onNext: {
        print("\($0)")
      })
      .disposed(by: disposeBag)
  }
}

extension BrandListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = 24.0
    return CGSize(width: width, height: height)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 36.0
  }
}
