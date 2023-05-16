//
//  ProductCategoryViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs
import RxSwift
import RxRelay
import RxDataSources
import RxCocoa
import UIKit

protocol ProductCategoryPresentableListener: AnyObject {
  var productCategorySections: BehaviorRelay<[ProductCategorySection]> { get }
}

final class ProductCategoryViewController: UIViewController, ProductCategoryPresentable, ProductCategoryViewControllable {
  
  weak var listener: ProductCategoryPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private struct CollectionViewMetric {
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    
    let headerHeight: CGFloat = 24
    
    let categoryListTopEdgeSpacing: CGFloat = 24.0
    let categoryListBottomEdgeSpacing: CGFloat = 44.0
    let categoryListHorizontalEdgeSpacing: CGFloat = 32.0
    let categoryListLineSpacing: CGFloat = 16.0
    let categoryListItemSpacing: CGFloat = 8.0
    var categoryListItemWidth: CGFloat { (deviceWidth - (categoryListHorizontalEdgeSpacing*2) - categoryListItemSpacing) / 2.0 }
    let categoryListItemHeight: CGFloat = 20.0
    
    let moodListTopEdgeSpacing: CGFloat = 24.0
    let moodListBottomEdgeSpacing: CGFloat = 44.0
    let moodListHorizontalEdgeSpacing: CGFloat = 24.0
    let moodListLineSpacing: CGFloat = 12.0
    let moodListItemSpacing: CGFloat = 12.0
    var moodListItemWidth: CGFloat { (deviceWidth - (moodListHorizontalEdgeSpacing*2) - moodListItemSpacing) / 2.0 }
    let moodListItemHeight: CGFloat = 70.0
  }
  
  private let collectionViewMetric: CollectionViewMetric = CollectionViewMetric()
  
  private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(
      ProductCategoryTextCell.self,
      forCellWithReuseIdentifier: ProductCategoryTextCell.identifier
    )
    
    $0.register(
      ProductCategoryImageCell.self,
      forCellWithReuseIdentifier: ProductCategoryImageCell.identifier
    )
    
    $0.register(
      ProductCategoryHeaderCell.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ProductCategoryHeaderCell.identifier
    )
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .link
    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    
    self.setupViews()
    self.setupCollectionView()
   
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
  
  let dataSource = RxCollectionViewSectionedReloadDataSource<ProductCategorySection>(
    configureCell: { dataSource, collectionView, indexPath, item in
            
      switch indexPath.section {
      case 0:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ProductCategoryTextCell.identifier,
          for: indexPath
        ) as? ProductCategoryTextCell
        cell?.setCellConfigure(text: item.title)

        return cell ?? UICollectionViewCell()
        
      case 1:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: ProductCategoryImageCell.identifier,
          for: indexPath
        ) as? ProductCategoryImageCell
        cell?.setCellConfigure(imageURL: item.imageURL, text: item.title)

        return cell ?? UICollectionViewCell()
        
      default:
        return UICollectionViewCell()
      }
    }, configureSupplementaryView: { dataSource, collectionview, title, indexPath in
      
      let header = collectionview.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: ProductCategoryHeaderCell.identifier,
        for: indexPath
      ) as? ProductCategoryHeaderCell
      
      header?.setCellConfigure(text: dataSource.sectionModels[indexPath.section].model)
      
      return header ?? UICollectionReusableView()
    }
  )
  
  
  private func setupCollectionView() {
    listener?.productCategorySections
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: {
        print("\($0)")
      })
      .disposed(by: disposeBag)
  }
}

extension ProductCategoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch indexPath.section {
    case 0: // 카테고리 별 TextCell
      return CGSize(width: collectionViewMetric.categoryListItemWidth, height: collectionViewMetric.categoryListItemHeight)
    case 1:
      return CGSize(width: collectionViewMetric.categoryListItemWidth, height: collectionViewMetric.moodListItemHeight)
    default:
      return CGSize(width: 0, height: 0)
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(
      width: collectionViewMetric.deviceWidth,
      height: collectionViewMetric.headerHeight
    )
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch section {
    case 0:
      return UIEdgeInsets(
        top: collectionViewMetric.categoryListTopEdgeSpacing,
        left: collectionViewMetric.categoryListHorizontalEdgeSpacing,
        bottom: collectionViewMetric.categoryListBottomEdgeSpacing,
        right: collectionViewMetric.categoryListHorizontalEdgeSpacing
      )
    case 1:
      return UIEdgeInsets(
        top: collectionViewMetric.moodListTopEdgeSpacing,
        left: collectionViewMetric.moodListHorizontalEdgeSpacing,
        bottom: collectionViewMetric.moodListBottomEdgeSpacing,
        right: collectionViewMetric.moodListHorizontalEdgeSpacing
      )
    default:
      return UIEdgeInsets.init()
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch section {
    case 0: return collectionViewMetric.categoryListLineSpacing
    case 1: return collectionViewMetric.moodListLineSpacing
    default: return 0.0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    switch section {
    case 0: return collectionViewMetric.categoryListItemSpacing
    case 1: return collectionViewMetric.moodListItemSpacing
    default: return 0.0
    }
  }
}
