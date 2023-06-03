//
//  MoodColorModalViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift
import UIKit
import CommonUI
import RxRelay

protocol MoodColorModalPresentableListener: AnyObject {
  
  var moodList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> { get }
  
  func dismissMoodColorModalVC()
}

final class MoodColorModalViewController: ModalViewController, MoodColorModalPresentable, MoodColorModalViewControllable {
  
  weak var listener: MoodColorModalPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.warningColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let moodCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.showsHorizontalScrollIndicator = false
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
        self.modalView.pin
          .horizontally()
          .bottom()
          .height(300)
  
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
      .height(0)
    
    moodCollectionView.pin
      .top(40)
      .horizontally()
      .height(30)
  }
  
  private func setupGestures() {
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
      self.listener?.dismissMoodColorModalVC()
    }
  }
  
  private func setupMoodCollectionView() {

    moodCollectionView.delegate = nil
    moodCollectionView.dataSource = nil
    
    listener?.moodList
      .bind(to: moodCollectionView.rx.items(
        cellIdentifier: FilterCell.identifier,
        cellType: FilterCell.self)
      ) { index, data, cell in
        cell.setupCellConfigure(text: data.category.title, isSelected: data.isSelected)
      }.disposed(by: disposeBag)
    
    moodCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension MoodColorModalViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let font: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    if let moodList = listener?.moodList.value {
      return CGSize(
        width: moodList[indexPath.row].category.title.size(withAttributes: [NSAttributedString.Key.font:font]).width + 24,
        height: 30
      )
    }
    return .zero
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 8.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
  }
}
