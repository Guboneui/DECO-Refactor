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
  
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let categoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .orange
    $0.register(SmallTextCell.self, forCellWithReuseIdentifier: SmallTextCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    print("AAAAA")
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
        self.modalView.pin
          .horizontally()
          .bottom()
          .height(300)
        
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
      .height(0)
    
    categoryCollectionView.pin.all()
  }
  
  private func setupGestures() {
  }
  
  private func setupCategoryCollectionView() {
    categoryCollectionView.dataSource = nil
    categoryCollectionView.delegate = nil
    listener?.categoryList
      .bind(to: categoryCollectionView.rx.items(
        cellIdentifier: SmallTextCell.identifier,
        cellType: SmallTextCell.self)
      ) { index, category, cell in
        cell.setupCellConfigure(text: category.category.title, isSelected: category.isSelected)
      }.disposed(by: disposeBag)
    
    categoryCollectionView.rx.modelSelected((category: ProductCategoryModel, Bool).self)
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
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    return CGSize(width: (deviceWidth-64) / 2.0, height: 20)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 18.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 28, left: 32, bottom: 28, right: 32)
  }
}
