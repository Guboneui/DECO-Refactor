//
//  HomeViewController.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import Util
import CommonUI

enum HomeType {
  case Recent
  case Popular
  case Follow
}

protocol HomePresentableListener: AnyObject {
}

final public class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
  
  weak var listener: HomePresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let type: BehaviorRelay<HomeType> = .init(value: .Recent)
  
  
  private let logoImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.logoDarkgray
    $0.contentMode = .scaleAspectFit
  }
  
  private let searchView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.lightGray1
    $0.makeCornerRadius(radius: 12)
  }
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.search
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .DecoColor.gray2
  }
  
  private let searchLabel: UILabel = UILabel().then {
    $0.text = "브랜드 및 상품 검색하기"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.gray1
  }
  
  private let noticeButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.bell)
    $0.tintColor = .DecoColor.gray4
  }
  
  private let recentButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("최신")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.tintColor = .DecoColor.gray4
  }
  
  private let popularButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("인기")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.tintColor = .DecoColor.lightGray1
  }
  
  private let followButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("팔로우")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.tintColor = .DecoColor.lightGray1
  }
  
  private lazy var segmentStackView: UIStackView = UIStackView(arrangedSubviews: [recentButton, popularButton, followButton]).then {
    $0.axis = .horizontal
    $0.spacing = 12
  }
  
  private let segmentBarView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.darkGray1
    $0.makeCornerRadius(radius: 1)
  }
  
  private let filterCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .yellow
  }
  
  private let segmentCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .orange
    $0.register(LargeTextCell.self, forCellWithReuseIdentifier: LargeTextCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    $0.collectionViewLayout = layout
    $0.isPagingEnabled = true
    $0.bounces = false
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupLayouts()
    self.setupGestures()
    self.setupBindings()
    
    segmentCollectionView.dataSource = self
    segmentCollectionView.delegate = self
  }
  
 
  
  private func setupLayouts() {
    self.view.addSubview(logoImageView)
    self.view.addSubview(noticeButton)
    self.view.addSubview(searchView)
    self.searchView.addSubview(searchImageView)
    self.searchView.addSubview(searchLabel)
    self.view.addSubview(segmentStackView)
    self.view.addSubview(segmentBarView)
    self.view.addSubview(filterCollectionView)
    self.view.addSubview(segmentCollectionView)
    
    logoImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.equalToSuperview().offset(22)
      make.width.equalTo(68)
      make.height.equalTo(22)
    }
    
    noticeButton.snp.makeConstraints { make in
      make.centerY.equalTo(logoImageView.snp.centerY)
      make.trailing.equalToSuperview().inset(18)
      make.size.equalTo(24)
    }
    
    searchView.snp.makeConstraints { make in
      make.centerY.equalTo(logoImageView.snp.centerY)
      make.leading.equalTo(logoImageView.snp.trailing).offset(22)
      make.trailing.equalTo(noticeButton.snp.leading).offset(-8)
      make.height.equalTo(30)
    }
    
    searchImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(10)
      make.size.equalTo(20)
    }
    
    searchLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(searchImageView.snp.trailing).offset(10)
      make.trailing.equalToSuperview()
    }
    
    segmentStackView.snp.makeConstraints { make in
      make.top.equalTo(searchView.snp.bottom).offset(30)
      make.leading.equalToSuperview().offset(30)
      make.height.equalTo(20)
    }
    
    view.layoutIfNeeded()
    
    segmentBarView.snp.makeConstraints { make in
      make.height.equalTo(2)
      make.top.equalTo(segmentStackView.snp.bottom).offset(6)
      make.leading.equalToSuperview().offset(30)
      make.width.equalTo(recentButton.frame.width)
    }
    
    filterCollectionView.snp.makeConstraints { make in
      make.top.equalTo(segmentBarView.snp.bottom).offset(21)
      make.horizontalEdges.equalToSuperview()
      make.height.equalTo(30)
    }
    
    segmentCollectionView.snp.makeConstraints { make in
      make.top.equalTo(filterCollectionView.snp.bottom).offset(12)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  private func setupGestures() {
    recentButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.type.accept(.Recent)
      }.disposed(by: disposeBag)
    
    
    popularButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.type.accept(.Popular)
      }.disposed(by: disposeBag)
    
    followButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.type.accept(.Follow)
      }.disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    type
      .observe(on: MainScheduler.instance)
      .skip(1)
      .subscribe(onNext: { [weak self] t in
        guard let self else { return }
//        UIView.animate(withDuration: 0.1) {[weak self] in
//          guard let inSelf = self else { return }
        
//          inSelf.view.layoutIfNeeded()
//        }
//        inSelf.updateSegmentBarLayout(at: inSelf.recentButton)
        
        switch t {
        case .Recent: self.updateSegmentBarLayout(at: self.recentButton)
        case .Popular: self.updateSegmentBarLayout(at: self.popularButton)
        case .Follow: self.updateSegmentBarLayout(at: self.followButton)
        }
        
        
        UIView.animate(withDuration: 0.25) { [weak self] in
          guard let inSelf = self else { return }
          switch t {
          case .Recent:
//            inSelf.updateSegmentBarLayout(at: inSelf.recentButton)
            inSelf.updateSegmentBarUI(with: .Recent)
            inSelf.segmentCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
          case .Popular:
            inSelf.updateSegmentBarUI(with: .Popular)
//            inSelf.updateSegmentBarLayout(at: inSelf.popularButton)
            inSelf.segmentCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
          case .Follow:
//            inSelf.updateSegmentBarLayout(at: inSelf.followButton)
            inSelf.updateSegmentBarUI(with: .Follow)
            inSelf.segmentCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .left, animated: true)
            
          }
          inSelf.view.layoutIfNeeded()
        }
        
      }).disposed(by: disposeBag)
  }
}

// MARK: SegmentBar Layout & UI
extension HomeViewController {
  private func updateSegmentBarLayout(at button: UIButton) {
//    UIView.animate(withDuration: 0.1) {[weak self] in
//      guard let self else { return }
      self.segmentBarView.snp.updateConstraints { make in
        make.width.equalTo(button.frame.width)
//      }
//      self.view.layoutIfNeeded()
    }
  }
  
  private func updateSegmentBarUI(with type: HomeType) {
    recentButton.tintColor = type == .Recent ? .DecoColor.gray4 : .DecoColor.lightGray1
    recentButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: type == .Recent ? .bold : .medium, size: 14)
    
    popularButton.tintColor = type == .Popular ? .DecoColor.gray4 : .DecoColor.lightGray1
    popularButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: type == .Popular ? .bold : .medium, size: 14)
    
    followButton.tintColor = type == .Follow ? .DecoColor.gray4 : .DecoColor.lightGray1
    followButton.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: type == .Follow ? .bold : .medium, size: 14)
  }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeTextCell.identifier, for: indexPath) as? LargeTextCell else { return UICollectionViewCell() }
    cell.setupCellConfigure(text: "\(indexPath)", isSelected: false)
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: segmentCollectionView.frame.width, height: segmentCollectionView.frame.height)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let x = scrollView.contentOffset.x
    let width: CGFloat = segmentCollectionView.frame.width
    if x == 0.0 { type.accept(.Recent) }
    else if x == width * 1.0 { type.accept(.Popular) }
    else if x == width * 2.0 { type.accept(.Follow) }
    
    let spacing: CGFloat = 42.0

    segmentBarView.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(scrollView.contentOffset.x / width * spacing + 30)
    }
  }
}
