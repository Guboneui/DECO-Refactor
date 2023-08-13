//
//  ProductDetailViewController.swift
//  ProductDetail
//
//  Created by 구본의 on 2023/06/14.
//

import UIKit

import Util
import CommonUI
import Entity

import RIBs
import RxSwift
import RxRelay

protocol ProductDetailPresentableListener: AnyObject {
  var productPostings: BehaviorRelay<[PostingDTO]> { get }
  
  func popProductDetailVC(with popType: PopType)
  func loadToSafariLink()
  func fetchBookmark()
  func fetchProductPostings(createdAt: Int) async
}

final class ProductDetailViewController: UIViewController, ProductDetailPresentable, ProductDetailViewControllable {
  
  weak var listener: ProductDetailPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: false
  )
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.showsVerticalScrollIndicator = false
    $0.bounces = false
  }
  
  private let productImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .DecoColor.lightBackground
    $0.contentMode = .scaleAspectFill
    $0.makeCornerRadius(radius: 16)
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  private let linkBaseView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.secondaryColor
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    $0.layer.cornerRadius = 16
  }
  
  private let showDetailLabel: UILabel = UILabel().then {
    $0.text = "자세히 보러가기"
    $0.textColor = .DecoColor.whiteColor
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
  }
  
  private let linkImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.loadingWhite
    $0.contentMode = .scaleAspectFit
  }
  
  private let productInfoView: ProductInfoView = ProductInfoView()
  private let productSailInfoView: ProductSailInfoView = ProductSailInfoView()
  
  private let otherUserUsedLabel: UILabel = UILabel().then {
    $0.text = "다른 유저들은 이렇게 활용했어요"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.darkGray2
    $0.isHidden = true
  }
  
  private let productPostingCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.isScrollEnabled = false
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    $0.isHidden = true
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let cvHorizontalEdge: CGFloat = 18.0
  private let cvSpacing: CGFloat = 10
  private var cvHeight: CGFloat = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupProductPostingCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popProductDetailVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(productImageView)
    self.scrollView.addSubview(linkBaseView)
    self.linkBaseView.addSubview(linkImageView)
    self.linkBaseView.addSubview(showDetailLabel)
    self.scrollView.addSubview(productInfoView)
    self.scrollView.addSubview(productSailInfoView)
    self.scrollView.addSubview(otherUserUsedLabel)
    self.scrollView.addSubview(productPostingCollectionView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    scrollView.pin
      .below(of: navigationBar)
      .horizontally()
      .bottom()
    
    productImageView.pin
      .top(10)
      .horizontally(6)
      .aspectRatio(1.0)
    
    linkBaseView.pin
      .below(of: productImageView)
      .horizontally(6)
      .height(42)
    
    linkImageView.pin
      .vertically(14)
      .right(20)
      .size(14)
    
    showDetailLabel.pin
      .vCenter()
      .before(of: linkImageView)
      .marginRight(12)
      .sizeToFit()
    
    productInfoView.pin
      .below(of: linkBaseView)
      .horizontally()
      .marginTop(15)
    
    productSailInfoView.pin
      .below(of: productInfoView, aligned: .left)
      .marginTop(20)
      .marginLeft(24)
      .sizeToFit()
    
    otherUserUsedLabel.pin
      .below(of: productSailInfoView)
      .horizontally(20)
      .marginTop(64)
      .sizeToFit(.width)

    productPostingCollectionView.pin
      .below(of: otherUserUsedLabel)
      .horizontally()
      .height(cvHeight)
      .marginTop(28)
    
    scrollView.contentSize = CGSize(width: view.frame.width, height: productPostingCollectionView.frame.maxY)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popProductDetailVC(with: .BackButton)
    }
    
    showDetailLabel.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.loadToSafariLink()
      }.disposed(by: disposeBag)
    
    linkImageView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        self.listener?.loadToSafariLink()
      }.disposed(by: disposeBag)
    
    self.productInfoView.didTapBookmarkButton = { [weak self] in
      guard let self else { return }
      self.listener?.fetchBookmark()
    }
    
    self.productSailInfoView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        let popup = ProductSailInfoPopupViewController()
        popup.modalPresentationStyle = .overFullScreen
        self.present(popup, animated: false, completion: nil)
      }.disposed(by: disposeBag)
  }
  
  // MARK: - ProductDetailPresentable
  func setProductInfo(with productInfo: ProductDetailDTO) {
    productInfoView.setProductInfo(productInfo: productInfo)
    productImageView.loadImage(imageUrl: productInfo.product.imageUrl)
    setupLayouts()
  }
  
  private func setupProductPostingCollectionView() {
    productPostingCollectionView.delegate = nil
    productPostingCollectionView.dataSource = nil
    
    listener?.productPostings
      .share()
      .observe(on: MainScheduler.instance)
      .bind { [weak self] postings in
        guard let self else { return }
        if !postings.isEmpty {
          self.otherUserUsedLabel.isHidden = false
          self.productPostingCollectionView.isHidden = false
        }
        
        let postingCount: Int = postings.count
        var lineCount: Int
        let cvItemHeight: CGFloat = (self.view.frame.width - (self.cvHorizontalEdge*2) - self.cvSpacing) / 2.0
        if postingCount % 2 == 0 { lineCount = postingCount / 2 }
        else { lineCount = postingCount / 2 + 1 }
        
        let cvHeight: Int = (lineCount * Int(cvItemHeight)) + (lineCount-1) * Int(self.cvSpacing)
        self.cvHeight = CGFloat(cvHeight)
        
        self.productPostingCollectionView.pin
          .below(of: self.otherUserUsedLabel)
          .horizontally()
          .height(CGFloat(cvHeight))
          .marginTop(28)
        
        self.scrollView.contentSize = CGSize(
          width: self.view.frame.width,
          height: self.productPostingCollectionView.frame.maxY
        )
        
      }.disposed(by: disposeBag)
    
    listener?.productPostings
      .bind(to: productPostingCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { [weak self] index, posting, cell in
        guard let self else { return }
        cell.setupCellConfigure(type: .DefaultType, imageURL: posting.imageUrl ?? "")
        cell.contentView.makeCornerRadius(radius: 10)
      }.disposed(by: disposeBag)
    
    productPostingCollectionView.rx.willDisplayCell
      .map{$0.at.row}
      .subscribe(onNext: { [weak self] index in
        guard let self else { return }
        if let productPostings = self.listener?.productPostings.value,
           productPostings.count - 1 == index,
           let lastCreatedAt = productPostings[index].createdAt
        {
          Task.detached { [weak self] in
            guard let inSelf = self else { return }
            await
            inSelf.listener?.fetchProductPostings(createdAt: lastCreatedAt)
          }
        }
        
      }).disposed(by: disposeBag)
    
    productPostingCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    
  }
  
  func showToast(status: Bool) {
    ToastManager.shared.showToast(status ? .DeleteBookmark : .AddBookmark)
  }
  
  func showEmptyLinkToast() {
    ToastManager.shared.showToast(.EmptyProductLink)
  }
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let screenWidth: CGFloat = view.frame.width
    let cellSize: CGFloat = (screenWidth - (cvHorizontalEdge*2) - cvSpacing) / 2.0
    return CGSize(width: cellSize, height: cellSize)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return cvSpacing
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return cvSpacing
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: cvHorizontalEdge, bottom: 0, right: cvHorizontalEdge)
  }
}
