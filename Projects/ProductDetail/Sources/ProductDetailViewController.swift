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


protocol ProductDetailPresentableListener: AnyObject {
  func popProductDetailVC(with popType: PopType)
  func loadToSafariLink()
  
  func fetchBookmark()
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
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
      .marginLeft(20)
      .sizeToFit()
    
    scrollView.contentSize = CGSize(width: view.frame.width, height: productSailInfoView.frame.maxY)
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
}
