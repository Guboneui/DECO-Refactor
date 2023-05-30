//
//  FollowingListViewController.swift
//  User
//
//  Created by 구본의 on 2023/05/30.
//

import UIKit

import Entity

import RIBs
import RxSwift
import RxRelay

protocol FollowingListPresentableListener: AnyObject {
  var userID: Int { get }
  var followingList: BehaviorRelay<[UserDTO]> { get }
  var copiedFollowingList: [UserDTO] { get }
  
  func fetchFollowingList(with name: String)
  func follow(targetUserID: Int)
  func unfollow(targetUserID: Int)
  func changeFollowersState(with userInfo: UserDTO, index: Int)
  func showOriginFollowingList()
  func showFilteredFollowingList(with nickname: String)
}

final class FollowingListViewController: UIViewController, FollowingListPresentable, FollowingListViewControllable {
  
  weak var listener: FollowingListPresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let searchBarBaseView: UIView = UIView().then {
    $0.makeCornerRadius(radius: 8)
    $0.backgroundColor = .DecoColor.lightBackground
  }
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.searchGray2
    $0.contentMode = .scaleAspectFit
  }
  
  private let searchTextField: UITextField = UITextField().then {
    $0.placeholder = "검색하기"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textColor = .DecoColor.darkGray2
    $0.tintColor = .DecoColor.darkGray2
    $0.clearButtonMode = .whileEditing
  }
  
  private let followingListCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(FollowListCell.self, forCellWithReuseIdentifier: FollowListCell.identifier)
    $0.bounces = false
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
  }
  
  private let emptyListNoticeTitleLabel: UILabel = UILabel().then {
    $0.text = "앗! 내가 찾는 유저가 없어요."
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textAlignment = .center
    $0.textColor = .DecoColor.darkGray2
  }
  
  private let emptyListNoticeSubtitleLabel: UILabel = UILabel().then {
    $0.text = "유저 이름을 바르게 입력했는지 확인해 보세요."
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textAlignment = .center
    $0.textColor = .DecoColor.gray2
  }
  
  private lazy var emptyListNoticeStackView: UIStackView = UIStackView(
    arrangedSubviews: [
      emptyListNoticeTitleLabel,
      emptyListNoticeSubtitleLabel
    ]).then {
      $0.axis = .vertical
      $0.spacing = 8
      $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setFollowingListCollectionView()
    self.searchTextFieldBinding()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(searchBarBaseView)
    self.searchBarBaseView.addSubview(searchImageView)
    self.searchBarBaseView.addSubview(searchTextField)
    self.view.addSubview(followingListCollectionView)
    self.view.addSubview(emptyListNoticeStackView)
  }
  
  private func setupLayouts() {
    searchBarBaseView.pin
      .top()
      .horizontally(20)
      .height(32)
    
    searchImageView.pin
      .vCenter()
      .left(12)
      .size(20)
    
    searchTextField.pin
      .vCenter()
      .left(to: searchImageView.edge.right)
      .right(12)
      .marginLeft(8)
      .height(18)
    
    followingListCollectionView.pin
      .below(of: searchBarBaseView)
      .horizontally()
      .bottom()
      .marginTop(10)
    
    emptyListNoticeStackView.pin
      .horizontally()
      .vCenter()
      .height(45)
      .marginBottom(50)
  }
  
  private func setFollowingListCollectionView() {
    listener?.followingList.bind(to: followingListCollectionView.rx.items(
      cellIdentifier: FollowListCell.identifier,
      cellType: FollowListCell.self)
    ) { [weak self] index, userInfo, cell in
      guard let self else { return }
      if let userID = self.listener?.userID {
        cell.setupCellConfigure(with: userInfo, userID: userID)
        
        cell.didTapFollowButton = { [weak self] in
          guard let inSelf = self else { return }
          
          if userInfo.followStatus { inSelf.listener?.unfollow(targetUserID: userInfo.userId) }
          else { inSelf.listener?.follow(targetUserID: userInfo.userId) }
          
          inSelf.listener?.changeFollowersState(with: userInfo, index: index)
        }
      }
    }.disposed(by: disposeBag)
    
    followingListCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func searchTextFieldBinding() {
    searchTextField.rx.text
      .observe(on: MainScheduler.instance)
      .distinctUntilChanged()
      .skip(1)
      .compactMap{$0}
      .map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
      .subscribe(onNext: { [weak self] searchText in
        guard let self else { return }
        if searchText == "" { self.listener?.showOriginFollowingList() }
        else { self.listener?.showFilteredFollowingList(with: searchText) }
      }).disposed(by: disposeBag)
  }
  
  func showNoticeLabel(isEmptyArray: Bool) {
    self.emptyListNoticeStackView.isHidden = !isEmptyArray
  }
}

extension FollowingListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 74)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0.0
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
    return UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
  }
}
