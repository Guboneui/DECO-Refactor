//
//  MoodModalViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import UIKit

import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol MoodModalPresentableListener: AnyObject {
  var moodList: BehaviorRelay<[(mood: ProductCategoryModel, isSelected: Bool)]> { get }
  
  func selectedMood(mood: ProductCategoryModel, _ completion: (()->())?)
  func dismissMoodModalVC()
}

final class MoodModalViewController: ModalViewController, MoodModalPresentable, MoodModalViewControllable {
  
  weak var listener: MoodModalPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let cellHorizontalEdgeInset: CGFloat = 32.0
  private let cellVerticalEdgeInset: CGFloat = 24
  private let cellLineSpacing: CGFloat = 18.0
  private let cellWidth: CGFloat = (UIScreen.main.bounds.width-64)
  private let cellHeight: CGFloat = 20.0
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let moodCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(LargeTextCell.self, forCellWithReuseIdentifier: LargeTextCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    self.setupMoodCollectionView()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.setupLayouts()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if isShow == false {
      UIView.animate(withDuration: 0.3) { [weak self] in
        guard let self else { return }
        let categoryCount: Int = self.listener?.moodList.value.count ?? 0
        let collectionViewHeight: Int = (categoryCount*Int(self.cellHeight)) + (categoryCount-1) * Int(self.cellLineSpacing) + (2 * Int(self.cellVerticalEdgeInset))
        let bottomMargin: Int = UIDevice.current.hasNotch ? 60 - Int(self.cellVerticalEdgeInset) : 0
        
        self.modalView.pin
          .horizontally()
          .bottom()
          .height(CGFloat(collectionViewHeight + bottomMargin))
        
        self.moodCollectionView.pin.all()
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  private func setupViews() {
    self.view.addSubview(modalView)
    self.modalView.addSubview(moodCollectionView)
  }
  
  private func setupLayouts() {
    modalView.pin
      .horizontally()
      .bottom()
    
    moodCollectionView.pin.all()
  }
  
  private func setupGestures() {
  }
  
  private func setupMoodCollectionView() {
    moodCollectionView.dataSource = nil
    moodCollectionView.delegate = nil
    
    listener?.moodList
      .bind(to: moodCollectionView.rx.items(
        cellIdentifier: LargeTextCell.identifier,
        cellType: LargeTextCell.self)
      ) { index, category, cell in
        cell.setupCellConfigure(text: category.mood.title, isSelected: category.isSelected)
      }.disposed(by: disposeBag)
    
    moodCollectionView.rx
      .modelSelected((mood: ProductCategoryModel, Bool).self)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.selectedMood(mood: $0.mood, { [weak self] in
          guard let inSelf = self else { return }
          inSelf.didTapBackgroundView()
        })
      }).disposed(by: disposeBag)
    
    moodCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
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
      
      self.moodCollectionView.pin.all()
      
    } completion: { [weak self] _ in
      guard let self else { return }
      self.listener?.dismissMoodModalVC()
    }
  }
}

extension MoodModalViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
