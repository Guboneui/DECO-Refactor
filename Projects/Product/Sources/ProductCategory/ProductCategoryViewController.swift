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

//final class BoardHeaderView: UICollectionReusableView {
//  
//  // MARK: - Property
//  
//  private lazy var titleLabel = UILabel().then {
//    $0.translatesAutoresizingMaskIntoConstraints = false
//    $0.font = .systemFont(ofSize: 16.0, weight: .bold)
//  }
//  
//  override init(frame: CGRect) {
//    super.init(frame: .zero)
//    
//    backgroundColor = .systemGreen
//    addSubview(titleLabel)
//    
//    NSLayoutConstraint.activate([
//      titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
//      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//      titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//      titleLabel.widthAnchor.constraint(equalToConstant: 100),
//      titleLabel.heightAnchor.constraint(equalToConstant: 100)
//      
//    ])
//      
////    titleLabel.snp.makeConstraints {
////      $0.leading.equalToSuperview().inset(16.0)
////      $0.centerY.equalToSuperview()
////    }
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  func configureHeader(with title: String) {
//    self.titleLabel.text = title
//  }
//}



public typealias ProductCategorySection = SectionModel<String, ProductCategoryModel>

public struct ProductCategoryModel {
  var text: String
  var image: String?
}

extension ProductCategoryModel: IdentifiableType {
  public var identity: String {
    return UUID().uuidString
  }
}

protocol ProductCategoryPresentableListener: AnyObject {
}

final class ProductCategoryViewController: UIViewController, ProductCategoryPresentable, ProductCategoryViewControllable {
  
  weak var listener: ProductCategoryPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  
  private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    //$0.register(ProductCategoryHeaderCell.self, forCellWithReuseIdentifier: ProductCategoryHeaderCell.identifier)
    
    $0.register(ProductCategoryTextCell.self, forCellWithReuseIdentifier: ProductCategoryTextCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 4
    layout.minimumInteritemSpacing = 4
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = .DecoColor.kakaoColor
  }
  
  
    private var sections: [ProductCategorySection] = [
      ProductCategorySection(model: "AAA", items: [ProductCategoryModel(text: "1"), ProductCategoryModel(text: "2"), ProductCategoryModel(text: "3")]),
      ProductCategorySection(model: "BBB", items: [ProductCategoryModel(text: "111"), ProductCategoryModel(text: "222"), ProductCategoryModel(text: "333")]),
    ]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .link
    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    
    self.collectionView.register(
      ProductCategoryTextCell.self,
      forCellWithReuseIdentifier: ProductCategoryTextCell.identifier
    )
    self.collectionView.register(
      ProductCategoryHeaderCell.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ProductCategoryHeaderCell.identifier
    )
    
    
    
    self.setupViews()
    setupBind()
    
    
    
    
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
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProductCategoryTextCell.identifier,
        for: indexPath
      ) as? ProductCategoryTextCell
      cell?.setCellConfigure(text: item.text)
      
      return cell ?? UICollectionViewCell()
      
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
  
  
  private func setupBind() {
    
    Observable.just(sections)
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
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: view.frame.width, height: 40)
  }
}
