//
//  MoodColorModalViewController.swift
//  Product
//
//  Created by 구본의 on 2023/06/02.
//

import RIBs
import RxSwift
import UIKit
import Util
import CommonUI
import RxRelay

protocol MoodColorModalPresentableListener: AnyObject {
  
  var moodList: BehaviorRelay<[(category: ProductCategoryModel, isSelected: Bool)]> { get }
  var colorList: BehaviorRelay<[(color: ProductColorModel, isSelected: Bool)]> { get }
  
  func updateSelectedFilterStream(moodList: [ProductCategoryModel], colorList: [ProductColorModel])
  func dismissMoodColorModalVC()
}

final class MoodColorModalViewController: ModalViewController, MoodColorModalPresentable, MoodColorModalViewControllable {
  
  weak var listener: MoodColorModalPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let moodLabel: UILabel = UILabel().then {
    $0.text = "무드"
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
  }
  
  private let moodCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
    $0.bounces = false
    $0.showsHorizontalScrollIndicator = false
    $0.setupSelectionFilterLayout(inset: 28)
    
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
  
  private let moodCvHeight: CGFloat = 30
  
  private let colorCvHorizontalItemSpacing: CGFloat = 36
  private let colorCvVerticalItemSpacing: CGFloat = 24
  private let colorCvHorizontalEdgeSpacing: CGFloat = 34
  private let colorCvHeight: CGFloat = 228
  private let colorCvItemHeight: CGFloat = 60
  private lazy var colorCvItemWidth: CGFloat = (deviceWidth - (colorCvHorizontalEdgeSpacing * 2) - (colorCvHorizontalItemSpacing * 4)) / 5
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    self.setupMoodCollectionView()
    self.setupColorCollectionView()
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
          .height(self.editFilterButtonView.frame.maxY + (UIDevice.current.hasNotch ? 40 : 24))
        
      } completion: { [weak self] _ in
        guard let self else { return }
        self.isShow = true
      }
    }
  }
  
  private func setupViews() {
    self.view.addSubview(modalView)
    self.modalView.addSubview(moodLabel)
    self.modalView.addSubview(moodCollectionView)
    self.modalView.addSubview(colorLabel)
    self.modalView.addSubview(colorCollectionView)
    self.modalView.addSubview(editFilterButtonView)
  }
  
  private func setupLayouts() {
    modalView.pin
      .horizontally()
      .bottom()
      .height(0)
    
    moodLabel.pin
      .topLeft(28)
      .sizeToFit()
    
    moodCollectionView.pin
      .below(of: moodLabel)
      .horizontally()
      .height(moodCvHeight)
      .marginTop(16)
    
    colorLabel.pin
      .below(of: moodCollectionView)
      .left(28)
      .marginTop(28)
      .sizeToFit()
    
    colorCollectionView.pin
      .below(of: colorLabel)
      .horizontally()
      .height(colorCvHeight)
      .marginTop(16)
    
    editFilterButtonView.pin
      .below(of: colorCollectionView)
      .horizontally()
      .marginTop(28)
      .sizeToFit()
  }
  
  private func setupGestures() {
    editFilterButtonView.didTapResetButton = { [weak self] in
      guard let self else { return }
      let clearMoodList = self.listener?.moodList.value.map{($0.category, false)}
      let clearColorList = self.listener?.colorList.value.map{($0.color, false)}
      self.listener?.moodList.accept(clearMoodList ?? [])
      self.listener?.colorList.accept(clearColorList ?? [])
    }
    
    editFilterButtonView.didTapSelectButton = { [weak self] in
      guard let self else { return }
      let selectedMoodList: [ProductCategoryModel] = self.listener?.moodList.value.filter{$0.isSelected}.map{$0.category} ?? []
      let selectedColorList: [ProductColorModel] = self.listener?.colorList.value.filter{$0.isSelected}.map{$0.color} ?? []
      self.listener?.updateSelectedFilterStream(moodList: selectedMoodList, colorList: selectedColorList)
      self.dismissModalAnimation()
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
        cell.setupCellConfigure(
          text: data.category.title,
          isSelected: data.isSelected
        )
      }.disposed(by: disposeBag)
    
    Observable.zip(
      moodCollectionView.rx.itemSelected,
      moodCollectionView.rx.modelSelected((category: ProductCategoryModel, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, model in
      guard let self else { return }
      var prevData: [(ProductCategoryModel, Bool)] = self.listener?.moodList.value ?? []
      let selectedData: (ProductCategoryModel, Bool) = (model.category, !model.isSelected)
      prevData[index.row] = selectedData
      self.listener?.moodList.accept(prevData)
    }).disposed(by: disposeBag)
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
