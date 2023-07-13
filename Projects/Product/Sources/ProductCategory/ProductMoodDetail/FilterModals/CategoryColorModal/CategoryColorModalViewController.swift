//
//  CategoryColorModalViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/05.
//

import RIBs
import RxSwift
import UIKit
import Util
import CommonUI
import RxRelay
import PinLayout

protocol CategoryColorModalPresentableListener: AnyObject {
  var categoryList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> { get }
  var colorList: BehaviorRelay<[(color: ProductColorModel, isSelected: Bool)]> { get }
  func updateSelectedFilterStream(categoryList: [ProductCategoryModel], colorList: [ProductColorModel])
  func dismissCategoryColorModalVC()
}

final class CategoryColorModalViewController: ModalViewController, CategoryColorModalPresentable, CategoryColorModalViewControllable {
  
  weak var listener: CategoryColorModalPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
  }
  
  private let categoryLabel: UILabel = UILabel().then {
    $0.text = "카테고리"
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  }
  
  private let categoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
    $0.bounces = false
    
    $0.showsHorizontalScrollIndicator = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
  }
  
  private let colorLabel: UILabel = UILabel().then {
    $0.text = "컬러"
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  }
  
  private let colorCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(ColorFilterCell.self, forCellWithReuseIdentifier: ColorFilterCell.identifier)
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
    $0.colorFilterLayout()
  }
  
  private let editFilterButtonView: EditFilterButtonView = EditFilterButtonView()
  
  private let deviceWidth: CGFloat = UIScreen.main.bounds.width
  
  private let categoryCvHeight: CGFloat = 30
  private let categoryCvItemHeight: CGFloat = 30
  private let categoryCvHorizontalItemSpacing: CGFloat = 8
  private let categoryCvHorizontalEdgeSpacing: CGFloat = 28
  
  private let colorCvHeight: CGFloat = 228
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    self.setupColorCollectionView()
    self.setupCategoryCollectionView()
    
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
          .height(100%)
          .maxHeight(self.editFilterButtonView.frame.maxY + (UIDevice.current.hasNotch ? 40 : 24))

        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.colorCollectionView.frame.maxY)
        
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  override func didTapBackgroundView() {
    self.dismissModalAnimation()
  }
  
  private func dismissModalAnimation() {
    UIView.animate(
      withDuration: dismissAnimationDuration,
      delay: dismissAnimationDelay,
      options: dismissAnimationOption
    ) { [weak self] in
      self?.backgroundAlphaView.alpha = 0.0
      self?.modalView.pin
        .horizontally()
        .bottom()
        .height(0)
    } completion: { [weak self] _ in
      self?.listener?.dismissCategoryColorModalVC()
    }
  }
  
  private func setupViews() {
    self.view.addSubview(modalView)
    self.modalView.addSubview(scrollView)
    self.scrollView.addSubview(categoryLabel)
    self.scrollView.addSubview(categoryCollectionView)
    self.scrollView.addSubview(colorLabel)
    self.scrollView.addSubview(colorCollectionView)
    self.modalView.addSubview(editFilterButtonView)
  }
  
  private func setupLayouts() {
    modalView.pin
      .horizontally()
      .bottom()
    
    scrollView.pin
      .top()
      .horizontally()
    
    categoryLabel.pin
      .topLeft(28)
      .sizeToFit()
    
    categoryCollectionView.pin
      .below(of: categoryLabel)
      .horizontally()
      .marginTop(16)
    
    colorLabel.pin
      .below(of: categoryCollectionView)
      .left(28)
      .marginTop(28)
      .sizeToFit()
    
    colorCollectionView.pin
      .below(of: colorLabel)
      .horizontally()
      .height(colorCvHeight)
      .marginTop(16)
    
    let deviceHeight: CGFloat = UIScreen.main.bounds.height - (UIDevice.current.hasNotch ? 47 : 20)
    let modalHeight: CGFloat = colorCollectionView.frame.maxY + 16 + 46 + (UIDevice.current.hasNotch ? 40 : 24)
    
    if deviceHeight >= modalHeight {
      scrollView.pin.height(self.colorCollectionView.frame.maxY)
    } else {
      let deviceHeight: CGFloat = UIScreen.main.bounds.height - (UIDevice.current.hasNotch ? 87 : 44) - 74
      scrollView.pin.height(deviceHeight)
    }
  
    editFilterButtonView.pin
      .below(of: scrollView)
      .horizontally()
      .marginTop(28)
      .sizeToFit()
  }
  
  private func setupGestures() {
    editFilterButtonView.didTapResetButton = { [weak self] in
      guard let self else { return }
      let clearCategoryList = self.listener?.categoryList.value.map{($0.category, false)}
      let clearColorList = self.listener?.colorList.value.map{($0.color, false)}

      self.listener?.categoryList.accept(clearCategoryList ?? [])
      self.listener?.colorList.accept(clearColorList ?? [])
    }
    
    editFilterButtonView.didTapSelectButton = { [weak self] in
      guard let self else { return }
      let selectedCategoryList: [ProductCategoryModel] = self.listener?.categoryList.value.filter{$0.isSelected}.map{$0.category} ?? []
      let selectedColorList: [ProductColorModel] = self.listener?.colorList.value.filter{$0.isSelected}.map{$0.color} ?? []
      self.listener?.updateSelectedFilterStream(categoryList: selectedCategoryList, colorList: selectedColorList)
      self.dismissModalAnimation()
    }
    
    scrollView.rx.contentOffset
      .map{$0.y}
      .subscribe(onNext: { [weak self] yOffset in
        guard let self else { return }
        if yOffset <= 0 {
          self.modalSwipeDismiss()
        }
      }).disposed(by: disposeBag)
    
  }
  
  private func modalSwipeDismiss() {
    modalView.rx.panGesture()
      .when(.began, .changed, .ended)
      .subscribe(onNext: { [weak self] recognize in
        guard let self else { return }
        let transform = recognize.translation(in: self.modalView)
        switch recognize.state {
        
        case .changed:

          if transform.y >= 0 {
            UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut) { [weak self] in
              guard let inSelf = self else { return }
              inSelf.modalView.transform = CGAffineTransform(translationX: 0, y: transform.y)
            }
          }
        case .ended:
          if transform.y >= 100 {
            self.dismissModalAnimation()
          } else {
            self.modalView.transform = .identity
          }
        default: break
        }
      }).disposed(by: disposeBag)
  }
  
  private func setupCategoryCollectionView() {
    
    categoryCollectionView.delegate = nil
    categoryCollectionView.dataSource = nil
    
    let categoryCount: Int = listener?.categoryList.value.count ?? 0
    var categoryLineCount: Int
    
    if categoryCount % 2 == 0 { categoryLineCount = categoryCount / 2 }
    else { categoryLineCount = categoryCount / 2 + 1 }
    let cvHeight: Int = (categoryLineCount * Int(categoryCvItemHeight)) + (categoryLineCount-1) * Int(categoryCvHorizontalItemSpacing)
    
    categoryCollectionView.pin
      .below(of: categoryLabel)
      .horizontally()
      .height(CGFloat(cvHeight))
      .marginTop(16)
    
    listener?.categoryList
      .share()
      .bind(to: categoryCollectionView.rx.items(
        cellIdentifier: FilterCell.identifier,
        cellType: FilterCell.self)
      ) { index, data, cell in
        cell.setupCellConfigure(
          text: data.category.title,
          isSelected: data.isSelected
        )
      }.disposed(by: disposeBag)
    
    Observable.zip(
      categoryCollectionView.rx.itemSelected,
      categoryCollectionView.rx.modelSelected((category: ProductCategoryModel, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, model in
      guard let self else { return }
      var prevData: [(ProductCategoryModel, Bool)] = self.listener?.categoryList.value ?? []
      let selectedData: (ProductCategoryModel, Bool) = (model.category, !model.isSelected)
      prevData[index.row] = selectedData
      self.listener?.categoryList.accept(prevData)
    }).disposed(by: disposeBag)
    
    categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setupColorCollectionView() {
    colorCollectionView.delegate = nil
    colorCollectionView.dataSource = nil
    
    listener?.colorList
      .bind(to: colorCollectionView.rx.items(
      cellIdentifier: ColorFilterCell.identifier,
      cellType: ColorFilterCell.self)
    ) { index, data, cell in
      cell.setupCellConfigure(
        text: data.color.name,
        image: data.color.image,
        isSelected: data.isSelected
      )
    }.disposed(by: disposeBag)
    
    Observable.zip(
      colorCollectionView.rx.itemSelected,
      colorCollectionView.rx.modelSelected((color: ProductColorModel, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, model in
      guard let self else { return }
      var prevData: [(ProductColorModel, Bool)] = self.listener?.colorList.value ?? []
      let selectedData: (ProductColorModel, Bool) = (model.color, !model.isSelected)
      prevData[index.row] = selectedData
      self.listener?.colorList.accept(prevData)
    }).disposed(by: disposeBag)
  }
}

extension CategoryColorModalViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case categoryCollectionView:
      let cellWidth: CGFloat = (view.frame.width - (categoryCvHorizontalEdgeSpacing * 2) - categoryCvHorizontalItemSpacing) / 2.0
      return CGSize(width: cellWidth, height: categoryCvItemHeight)
    default: return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView {
    case categoryCollectionView: return categoryCvHorizontalItemSpacing
    default: return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView {
    case categoryCollectionView: return categoryCvHorizontalItemSpacing
    default: return .zero
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch collectionView {
    case categoryCollectionView:
      return UIEdgeInsets(
        top: 0,
        left: categoryCvHorizontalEdgeSpacing,
        bottom: 0,
        right: categoryCvHorizontalEdgeSpacing
      )
    default: return .zero
    }
  }
}
