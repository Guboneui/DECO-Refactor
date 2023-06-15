//
//  SearchUserViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import UIKit

import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol SearchUserPresentableListener: AnyObject {
  var userList: BehaviorRelay<[SearchUserDTO]> { get }
}

final class SearchUserViewController: UIViewController, SearchUserPresentable, SearchUserViewControllable {
  
  weak var listener: SearchUserPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let userCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(SearchUserCell.self, forCellWithReuseIdentifier: SearchUserCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupUserListCollectionView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(userCollectionView)
  }
  
  private func setupLayouts() {
    userCollectionView.pin.all()
  }
  
  private func setupUserListCollectionView() {
    userCollectionView.delegate = nil
    userCollectionView.dataSource = nil
    
    listener?.userList
      .bind(to: userCollectionView.rx.items(
        cellIdentifier: SearchUserCell.identifier,
        cellType: SearchUserCell.self)
      ) { index, profile, cell in
        cell.setupCellConfigure(
          profileImageURL: profile.imageUrl,
          userNickname: profile.user.nickname,
          userProfileName: profile.profileName
        )
      }.disposed(by: disposeBag)
    
    userCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
}

extension SearchUserViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: UIScreen.main.bounds.width,
      height: 50
    )
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 12
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 12
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: 20,
      left: 0,
      bottom: 20,
      right: 0
    )
  }
}
