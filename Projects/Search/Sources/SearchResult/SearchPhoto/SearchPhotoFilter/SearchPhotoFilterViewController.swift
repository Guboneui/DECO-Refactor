//
//  SearchPhotoFilterViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/16.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
import FlexLayout

protocol SearchPhotoFilterPresentableListener: AnyObject {
  
  var boardCategoryList: BehaviorRelay<[(category: BoardCategoryDTO, isSelected: Bool)]> { get }
  var moodCategoryList: BehaviorRelay<[(category: ProductMoodDTO, isSelected: Bool)]> { get }
  var colorCategoryList: BehaviorRelay<[(color: ProductColorModel, isSelected: Bool)]> { get }
  
  func updateSearchPhotoSelectedFilterStream(categoryList: [BoardCategoryDTO], moodList: [ProductMoodDTO], colorList: [ProductColorModel])
  func dismissFilterModalVC()
}

final class SearchPhotoFilterViewController: ModalViewController, SearchPhotoFilterPresentable, SearchPhotoFilterViewControllable {
  
  weak var listener: SearchPhotoFilterPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let modalView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadiusOnlyTop(radius: 16)
  }
  
  private let categoryLabel: UILabel = UILabel().then {
    let text = "카테고리"
    $0.textColor = .DecoColor.darkGray2
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 12)
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.DecoFont.getFont(with: .Suit, type: .bold, size: 12),
      .underlineStyle: NSUnderlineStyle.single.rawValue,
      .underlineColor: UIColor.DecoColor.darkGray2
    ]
    
    let attrString = NSAttributedString(string: text, attributes: attributes)
    $0.attributedText = attrString
  }
  
  private let infoImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.info
    $0.contentMode = .scaleAspectFit
  }
  
  private let categoryFlexView: UIView = UIView()
  
  private let categoryCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
    $0.bounces = false
    
    $0.showsHorizontalScrollIndicator = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
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
    
    $0.showsHorizontalScrollIndicator = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
  }
  
  private let editFilterButtonView: EditFilterButtonView = EditFilterButtonView()
  
  private let deviceWidth: CGFloat = UIScreen.main.bounds.width
  
  private let categoryCvHeight: CGFloat = 30
  private let categoryCvItemHeight: CGFloat = 30
  private let categoryCvHorizontalItemSpacing: CGFloat = 8
  private let categoryCvHorizontalEdgeSpacing: CGFloat = 28
  
  private let moodCvHeight: CGFloat = 30
  private let moodCvItemHeight: CGFloat = 30
  private let moodCvHorizontalItemSpacing: CGFloat = 8
  private let moodCvHorizontalEdgeSpacing: CGFloat = 28
  
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
    self.setupBoardCategoryCollectionView()
    self.setupMoodCategoryCollectionView()
    self.setupColorCategoryCollectionView()
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
    self.modalView.addSubview(categoryFlexView)
    self.modalView.addSubview(categoryCollectionView)
    self.modalView.addSubview(moodLabel)
    self.modalView.addSubview(moodCollectionView)
    self.modalView.addSubview(colorLabel)
    self.modalView.addSubview(colorCollectionView)
    self.modalView.addSubview(editFilterButtonView)
    
    categoryFlexView.flex.direction(.row).define { flex in
      flex.addItem(categoryLabel)
      flex.addItem(infoImageView).marginLeft(2).size(17)
    }
  }
  
  private func setupLayouts() {
    modalView.pin
      .horizontally()
      .bottom()
    
    categoryFlexView.pin
      .topLeft(28)
      .height(17)
    
    categoryCollectionView.pin
      .below(of: categoryFlexView)
      .horizontally()
      .height(categoryCvHeight)
      .marginTop(16)
    
    moodLabel.pin
      .below(of: categoryCollectionView)
      .left(28)
      .marginTop(28)
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
    
    categoryFlexView.flex.layout(mode: .adjustWidth)
  }
  
  private func setupGestures() {
    categoryFlexView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.makeCategoryInfoPopup()
      }.disposed(by: disposeBag)
    
    editFilterButtonView.didTapResetButton = { [weak self] in
      guard let self else { return }
      let clearCategoryList = self.listener?.boardCategoryList.value.map{($0.category, false)}
      let clearMoodList = self.listener?.moodCategoryList.value.map{($0.category, false)}
      let clearColorList = self.listener?.colorCategoryList.value.map{($0.color, false)}
      
      self.listener?.boardCategoryList.accept(clearCategoryList ?? [])
      self.listener?.moodCategoryList.accept(clearMoodList ?? [])
      self.listener?.colorCategoryList.accept(clearColorList ?? [])
    }
    
    editFilterButtonView.didTapSelectButton = { [weak self] in
      guard let self else { return }
      let selectedBoardCategoryList: [BoardCategoryDTO] = self.listener?.boardCategoryList.value.filter{$0.isSelected}.map{$0.category} ?? []
      let selectedMoodCategoryList: [ProductMoodDTO] = self.listener?.moodCategoryList.value.filter{$0.isSelected}.map{$0.category} ?? []
      let selectedColorCategoryList: [ProductColorModel] = self.listener?.colorCategoryList.value.filter{$0.isSelected}.map{$0.color} ?? []
      
      self.listener?.updateSearchPhotoSelectedFilterStream(
        categoryList: selectedBoardCategoryList,
        moodList: selectedMoodCategoryList,
        colorList: selectedColorCategoryList
      )
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
      self.listener?.dismissFilterModalVC()
    }
  }
  
  
}

// MARK: CategoryInfoPopup

extension SearchPhotoFilterViewController {
  private func makeCategoryInfoPopup() {
    let popupBaseView = UIView().then {
      $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.15)
    }
    
    let categoryPopupImageView: UIImageView = UIImageView().then {
      $0.image = .DecoImage.categoryPopup
      $0.contentMode = .scaleAspectFit
    }
    
    // layout
    self.view.addSubview(popupBaseView)
    popupBaseView.addSubview(categoryPopupImageView)
    
    popupBaseView.pin.all()
    categoryPopupImageView.pin
      .below(of: categoryFlexView)
      .left(10)
      .height(92)
      .marginTop(10)
      .aspectRatio()
    
    // gesture
    popupBaseView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        popupBaseView.removeFromSuperview()
      }.disposed(by: disposeBag)
    
  }
}

// MARK: Set CategoryCollectionView
extension SearchPhotoFilterViewController {
  private func setupBoardCategoryCollectionView() {
    categoryCollectionView.delegate = nil
    categoryCollectionView.dataSource = nil
    
    listener?.boardCategoryList
      .bind(to: categoryCollectionView.rx.items(
        cellIdentifier: FilterCell.identifier,
        cellType: FilterCell.self)
      ) { [weak self] index, filter, cell in
        guard let self else { return }
        cell.setupCellConfigure(text: filter.category.categoryName, isSelected: filter.isSelected)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      categoryCollectionView.rx.itemSelected,
      categoryCollectionView.rx.modelSelected((category: BoardCategoryDTO, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, selectedFilter in
      guard let self else { return }
      var boardCategoryList: [(BoardCategoryDTO, Bool)] = self.listener?.boardCategoryList.value ?? []
      let selectedData: (BoardCategoryDTO, Bool) = (selectedFilter.category, !selectedFilter.isSelected)
      boardCategoryList[index.row] = selectedData
      self.listener?.boardCategoryList.accept(boardCategoryList)
    }).disposed(by: disposeBag)
    
    categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setupMoodCategoryCollectionView() {
    moodCollectionView.delegate = nil
    moodCollectionView.dataSource = nil
    
    listener?.moodCategoryList
      .bind(to: moodCollectionView.rx.items(
        cellIdentifier: FilterCell.identifier,
        cellType: FilterCell.self)
      ) { [weak self] index, filter, cell in
        guard let self else { return }
        cell.setupCellConfigure(text: filter.category.name, isSelected: filter.isSelected)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      moodCollectionView.rx.itemSelected,
      moodCollectionView.rx.modelSelected((category: ProductMoodDTO, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, selectedFilter in
      guard let self else { return }
      var moodCategoryList: [(ProductMoodDTO, Bool)] = self.listener?.moodCategoryList.value ?? []
      let selectedData: (ProductMoodDTO, Bool) = (selectedFilter.category, !selectedFilter.isSelected)
      moodCategoryList[index.row] = selectedData
      self.listener?.moodCategoryList.accept(moodCategoryList)
    }).disposed(by: disposeBag)
    
    moodCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setupColorCategoryCollectionView() {
    colorCollectionView.delegate = nil
    colorCollectionView.dataSource = nil
    
    listener?.colorCategoryList
      .bind(to: colorCollectionView.rx.items(
        cellIdentifier: ColorFilterCell.identifier,
        cellType: ColorFilterCell.self)
      ) { [weak self] index, filter, cell in
        guard let self else { return }
        cell.setupCellConfigure(text: filter.color.name, image: filter.color.image, isSelected: filter.isSelected)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      colorCollectionView.rx.itemSelected,
      colorCollectionView.rx.modelSelected((color: ProductColorModel, isSelected: Bool).self)
    ).subscribe(onNext: { [weak self] index, selectedFilter in
      guard let self else { return }
      var colorCategoryList: [(ProductColorModel, Bool)] = self.listener?.colorCategoryList.value ?? []
      let selectedData: (ProductColorModel, Bool) = (selectedFilter.color, !selectedFilter.isSelected)
      colorCategoryList[index.row] = selectedData
      self.listener?.colorCategoryList.accept(colorCategoryList)
    }).disposed(by: disposeBag)
    
    colorCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension SearchPhotoFilterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case categoryCollectionView:
      let font: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .bold, size: 12)
      if let categoryList = listener?.boardCategoryList.value {
        return CGSize(
          width: categoryList[indexPath.row].category.categoryName.size(withAttributes: [NSAttributedString.Key.font:font]).width + (FilterCell.horizontalMargin * 2),
          height: categoryCvItemHeight
        )
      }
      return .zero
      
    case moodCollectionView:
      let font: UIFont = UIFont.DecoFont.getFont(with: .Suit, type: .bold, size: 12)
      if let moodList = listener?.moodCategoryList.value {
        return CGSize(
          width: moodList[indexPath.row].category.name.size(withAttributes: [NSAttributedString.Key.font:font]).width + (FilterCell.horizontalMargin * 2),
          height: moodCvItemHeight
        )
      }
      return .zero
    
    case colorCollectionView:
      return CGSize(
        width: colorCvItemWidth,
        height: colorCvItemHeight
      )
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
    case moodCollectionView: return moodCvHorizontalItemSpacing
    case colorCollectionView: return colorCvVerticalItemSpacing
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
    case moodCollectionView: return moodCvHorizontalItemSpacing
    case colorCollectionView: return colorCvHorizontalItemSpacing
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
      return UIEdgeInsets(top: 0, left: categoryCvHorizontalEdgeSpacing, bottom: 0, right: categoryCvHorizontalEdgeSpacing)
    case moodCollectionView:
      return UIEdgeInsets(top: 0, left: moodCvHorizontalEdgeSpacing, bottom: 0, right: moodCvHorizontalEdgeSpacing)
    case colorCollectionView:
      return UIEdgeInsets(top: 0, left: colorCvHorizontalEdgeSpacing, bottom: 0, right: colorCvHorizontalEdgeSpacing)
    default: return .zero
    }
  }
}
