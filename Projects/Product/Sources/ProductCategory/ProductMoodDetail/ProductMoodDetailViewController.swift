//
//  ProductMoodDetailViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import UIKit

import CommonUI
import Util

import RIBs
import RxSwift
import PinLayout
import FlexLayout

protocol ProductMoodDetailPresentableListener: AnyObject {
  func popProductMoodDetailVC(with popType: PopType)
}

final class ProductMoodDetailViewController: UIViewController, ProductMoodDetailPresentable, ProductMoodDetailViewControllable {
  
  weak var listener: ProductMoodDetailPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: true
  )
  
  private let navCategoryLabel: UILabel = UILabel().then {
    $0.text = "카테고리"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let navDropDownImage: UIImageView = UIImageView().then {
    $0.image = .DecoImage.listupDarkgray2
    $0.contentMode = .scaleAspectFit
  }
  
  private var navCategoryView: TouchAnimationView = TouchAnimationView().then {
    $0.backgroundColor = .orange
  }
  
  private let filterLabel: UILabel = UILabel().then {
    $0.text = "카테고리 • 컬러"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray1
  }
  
  private let filterImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.filter
    $0.contentMode = .scaleAspectFit
  }
  
  private let filterView: TouchAnimationView = TouchAnimationView().then {
    $0.backgroundColor = .green
  }
  
  private let selectedFilterCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .yellow
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.isHidden = true
  }
  
  private let productCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .green
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
      guard let self else { return }
      self.navCategoryLabel.text = "FlexLayout MarkDirty"
      self.navCategoryLabel.flex.markDirty()
      self.navCategoryView.flex.layout(mode: .adjustWidth)
      self.selectedFilterCollectionView.isHidden = false
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popProductMoodDetailVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.navigationBar.addSubview(navCategoryView)
    self.view.addSubview(filterView)
    self.view.addSubview(selectedFilterCollectionView)
    self.view.addSubview(productCollectionView)
    
    navCategoryView.flex.direction(.row).alignItems(.center).define { flex in
      flex.addItem(navCategoryLabel)
      flex.addItem(navDropDownImage).size(13).marginLeft(8)
    }
    
    filterView.flex.direction(.row).alignItems(.center).define { flex in
      flex.addItem(filterLabel)
      flex.addItem(filterImageView).size(26).marginLeft(4)
    }
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    navCategoryView.pin
      .left(84)
      .vCenter()
      .height(20)
    
    filterView.pin
      .below(of: navigationBar, aligned: .right)
      .height(26)
      .marginRight(12)
      .marginTop(12)
    
    selectedFilterCollectionView.pin
      .below(of: filterView)
      .horizontally()
      .height(30)
      .marginTop(24)
    
    productCollectionView.pin
      .below(of: visible([filterView, selectedFilterCollectionView]))
      .horizontally()
      .bottom()
      .marginTop(12)
      
    navCategoryView.flex.layout(mode: .adjustWidth)
    filterView.flex.layout(mode: .adjustWidth)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popProductMoodDetailVC(with: .BackButton)
    }
    
    self.navCategoryView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("카테고리 팝업")
      }.disposed(by: disposeBag)
    
    self.filterView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("필터 팝업")
        
      }.disposed(by: disposeBag)
  }
}
