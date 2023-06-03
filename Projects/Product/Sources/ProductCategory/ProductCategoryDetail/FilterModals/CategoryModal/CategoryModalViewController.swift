//
//  CategoryModalViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift
import UIKit
import CommonUI
import RxRelay

protocol CategoryModalPresentableListener: AnyObject {
  
  var categoryList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> { get }
  
  func selectedCategory(category: ProductCategoryModel, _ completion: (()->())?)
  func dismissCategoryModalVC()
}

final class CategoryModalViewController: ModalViewController, CategoryModalPresentable, CategoryModalViewControllable {
  
  
  weak var listener: CategoryModalPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let cellHorizontalEdgeInset: CGFloat = 32.0
  private let cellVerticalEdgeInset: CGFloat = 28.0
  private let cellLineSpacing: CGFloat = 18.0
  private let cellWidth: CGFloat = (UIScreen.main.bounds.width-64) / 2.0
  private let cellHeight: CGFloat = 20.0
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let categoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(LargeTextCell.self, forCellWithReuseIdentifier: LargeTextCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.setupLayouts()
    self.setupCategoryCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if isShow == false {
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let self else { return }
        let categoryCount: Int = self.listener?.categoryList.value.count ?? 0
        let collectionViewTotalLine: Int = Int(ceil(Double(categoryCount) / 2.0)) + 1
        let collectionViewHeight: Int = (collectionViewTotalLine*20) + (collectionViewTotalLine-1) * 18
        let bottomMargin: Int = 60
        
        self.modalView.pin
          .horizontally()
          .bottom()
          .height(CGFloat(collectionViewHeight + bottomMargin))
        
        self.categoryCollectionView.pin.all()
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  private func setupViews() {
    self.view.addSubview(modalView)
    self.modalView.addSubview(categoryCollectionView)
  }
  
  private func setupLayouts() {
    modalView.pin
      .horizontally()
      .bottom()
    
    categoryCollectionView.pin.all()
  }
  
  private func setupGestures() {
  }
  
  private func setupCategoryCollectionView() {
    categoryCollectionView.dataSource = nil
    categoryCollectionView.delegate = nil
    listener?.categoryList
      .bind(to: categoryCollectionView.rx.items(
        cellIdentifier: LargeTextCell.identifier,
        cellType: LargeTextCell.self)
      ) { index, category, cell in
        cell.setupCellConfigure(text: category.category.title, isSelected: category.isSelected)
      }.disposed(by: disposeBag)
    
    categoryCollectionView.rx
      .modelSelected((category: ProductCategoryModel, Bool).self)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.selectedCategory(category: $0.category) { [weak self] in
          guard let inSelf = self else { return }
          inSelf.didTapBackgroundView()
        }
      }).disposed(by: disposeBag)
    
    categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  override func didTapBackgroundView() {
    UIView.animate(
      withDuration: dismissAnimationDuration,
      delay: dismissAnimationDelay,
      options: dismissAnimationOption
    ) { [weak self] in
      guard let self else { return }
      self.backgroundAlphaView.alpha = 0.0
      self.modalView.pin
        .horizontally()
        .bottom()
        .height(0)
      
      self.categoryCollectionView.pin.all()
      
    } completion: { [weak self] _ in
      guard let self else { return }
      self.listener?.dismissCategoryModalVC()
    }
  }
}

extension CategoryModalViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return cellLineSpacing
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: cellVerticalEdgeInset,
      left: cellHorizontalEdgeInset,
      bottom: cellVerticalEdgeInset,
      right: cellHorizontalEdgeInset
    )
  }
}
