//
//  SearchBrandViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import UIKit

import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
import PinLayout
import FlexLayout

protocol SearchBrandPresentableListener: AnyObject {
  var brandList: BehaviorRelay<[BrandDTO]> { get }
}

final class SearchBrandViewController: UIViewController, SearchBrandPresentable, SearchBrandViewControllable {
  
  weak var listener: SearchBrandPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let brandCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(SearchBrandCell.self, forCellWithReuseIdentifier: SearchBrandCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupBrandListCollectionView() 
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(brandCollectionView)
  }
  
  private func setupLayouts() {
    brandCollectionView.pin.all()
  }
  
  private func setupBrandListCollectionView() {
    brandCollectionView.delegate = nil
    brandCollectionView.dataSource = nil
    
    listener?.brandList
      .bind(to: brandCollectionView.rx.items(
        cellIdentifier: SearchBrandCell.identifier,
        cellType: SearchBrandCell.self)
      ) { index, brandInfo, cell in
        cell.setupCellConfigure(
          brandImageURL: brandInfo.imageUrl,
          brandName: brandInfo.name
        )
      }.disposed(by: disposeBag)
    
    brandCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension SearchBrandViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
  }
}
