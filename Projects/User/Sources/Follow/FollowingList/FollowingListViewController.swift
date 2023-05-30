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
  
  func fetchFollowingList()
  func follow(targetUserID: Int)
  func unfollow(targetUserID: Int)
  func changeFollowersState(with userInfo: UserDTO, index: Int)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setFollowingListCollectionView()
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
