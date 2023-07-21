//
//  TargetUserProfileViewController.swift
//  User
//
//  Created by 구본의 on 2023/05/31.
//

import UIKit

import Util
import Entity
import CommonUI

import RIBs
import RxSwift
import RxRelay
import PinLayout

protocol TargetUserProfilePresentableListener: AnyObject {
  var targetUserProfileInfo: BehaviorRelay<ProfileDTO?> { get }
  var targetUserPostings: BehaviorRelay<[PostingDTO]> { get }
  func popTargetUserProfileVC(with popType: PopType)
  
  func fetchTargetUserPostings(createdAt: Int)
  func showAlertCurrentUserStatus()
  func didTapFollowButton()
  func pushFollowVC(with selectedFollowType: FollowTabType)
}

final class TargetUserProfileViewController: UIViewController, TargetUserProfilePresentable, TargetUserProfileViewControllable {
  
  weak var listener: TargetUserProfilePresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.bounces = false
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let profileView: ProfileView = ProfileView()
  private let backButton: UIButton = UIButton().then {
    $0.setImage(.DecoImage.arrowWhite)
    $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
  
  private let optionButton: UIButton = UIButton().then {
    $0.setImage(.DecoImage.moreWhite)
    $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
  
  private let followStatusButton: UIButton = UIButton(type: .system).then {
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.tintColor = .DecoColor.whiteColor
    $0.backgroundColor = .DecoColor.whiteColor
    $0.imageView?.contentMode = .scaleAspectFit
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let imageHorizontalInset: CGFloat = (screenWidth - 25.0) / 2.0
    $0.imageEdgeInsets = UIEdgeInsets(top: 9.5, left: imageHorizontalInset - 40, bottom: 9.5, right: imageHorizontalInset + 40)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
  }
  
  private let profileInfoView: ProfileInfoView = ProfileInfoView()
  
  private let targetUserPostingCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.bounces = false
    $0.isScrollEnabled = false
    $0.setupDefaultTwoColumnGridLayout()
  }
  
  private var userPostingCollectionViewHeight: CGFloat = 0.0
  
  private let stickyNavView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.isHidden = true
  }
  
  private let stickyBackButton: UIButton = UIButton().then {
    $0.setImage(.DecoImage.arrowDarkgray2)
    $0.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  }
  
  private let stickyNavTitleLabel: UILabel = UILabel().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textAlignment = .center
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let stickyFollowStatusButton: UIButton = UIButton(type: .system).then {
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
  }
  
  private let stickySuperAreaView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBindings()
    self.setupTargetUserPostingCollectionView()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popTargetUserProfileVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(profileView)
    self.profileView.addSubview(backButton)
    self.profileView.addSubview(optionButton)
    self.scrollView.addSubview(followStatusButton)
    self.scrollView.addSubview(profileInfoView)
    self.scrollView.addSubview(targetUserPostingCollectionView)
    self.view.addSubview(stickyNavView)
    self.stickyNavView.addSubview(stickyBackButton)
    self.stickyNavView.addSubview(stickyFollowStatusButton)
    self.stickyNavView.addSubview(stickyNavTitleLabel)
    self.view.addSubview(stickySuperAreaView)
  }
  
  private func setupLayouts() {
    scrollView.pin.all()
    
    profileView.pin
      .top(UIDevice().hasNotch ? -47 : -20)
      .horizontally()
      .height(UIScreen.main.bounds.width)
    
    backButton.pin
      .topLeft()
      .marginTop(UIDevice.current.hasNotch ? 48 : 20)
      .size(48)
    
    optionButton.pin
      .topRight()
      .marginTop(UIDevice.current.hasNotch ? 48 : 20)
      .size(48)
    
    followStatusButton.pin
      .below(of: profileView)
      .horizontally()
      .height(44)
    
    profileInfoView.pin
      .below(of: followStatusButton)
      .horizontally()
      .height(52)
    
    targetUserPostingCollectionView.pin
      .below(of: profileInfoView)
      .horizontally()
      .height(userPostingCollectionViewHeight)
      .marginTop(1)
    
    
    scrollView.contentSize = CGSize(
      width: view.frame.width,
      height: targetUserPostingCollectionView.frame.maxY
    )
    
    stickyNavView.pin
      .top(view.pin.safeArea)
      .horizontally()
      .height(48)
    
    stickyBackButton.pin
      .vertically()
      .left()
      .size(48)
    
    stickyFollowStatusButton.pin
      .vCenter()
      .right(16)
      .sizeToFit()
    
    stickyNavTitleLabel.pin
      .horizontallyBetween(
        stickyBackButton,
        and: stickyFollowStatusButton,
        aligned: .center
      ).height(20)
    
    
    stickySuperAreaView.pin
      .top()
      .horizontally()
      .above(of: stickyNavView)
  }
  
  private func setupGestures() {
    self.backButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.popTargetUserProfileVC(with: .BackButton)
      }.disposed(by: disposeBag)
    
    self.stickyBackButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.popTargetUserProfileVC(with: .BackButton)
      }.disposed(by: disposeBag)
    
    self.optionButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.showAlertCurrentUserStatus()
      }.disposed(by: disposeBag)
    
    self.followStatusButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.didTapFollowButton()
      }.disposed(by: disposeBag)
    
    self.profileInfoView.didTapFollowerView = { [weak self] in
      guard let self else { return }
      self.listener?.pushFollowVC(with: .Follower)
    }
    
    self.profileInfoView.didTapFollowingView = { [weak self] in
      guard let self else { return }
      self.listener?.pushFollowVC(with: .Following)
    }
    
    self.stickyFollowStatusButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.didTapFollowButton()
      }.disposed(by: disposeBag)
  }
  
  private func setupTargetUserPostingCollectionView() {
    targetUserPostingCollectionView.delegate = nil
    targetUserPostingCollectionView.dataSource = nil
    
    self.listener?.targetUserPostings
      .observe(on: MainScheduler.instance)
      .filter{!$0.isEmpty}
      .share()
      .bind { [weak self] in
        guard let self else { return }
        let cellHeight: CGFloat = (UIScreen.main.bounds.width - 5.0) / 2
        let lineCount: Int = Int(ceil(Double($0.count) / 2.0))
        let collectionViewHeight: CGFloat = (cellHeight + 5.0) * CGFloat(lineCount)
        self.userPostingCollectionViewHeight = collectionViewHeight
        self.setupLayouts()
      }.disposed(by: disposeBag)
    
    self.listener?.targetUserPostings
      .share()
      .bind(to: targetUserPostingCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { (index, data, cell) in
        cell.setupCellConfigure(type: .DefaultType, imageURL: data.imageUrl ?? "")
      }.disposed(by: disposeBag)
    
    self.targetUserPostingCollectionView.rx.willDisplayCell
      .map{$0.at}
      .subscribe(onNext: { [weak self] indexPath in
        guard let self else { return }
        
        if let potings = self.listener?.targetUserPostings.value,
           potings.count - 1 == indexPath.row,
           let lastCreatedAt = potings[indexPath.row].createdAt {
          self.listener?.fetchTargetUserPostings(createdAt: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
  }
  
  
  private func setupBindings() {
    scrollView.rx.contentOffset
      .map { $0.y }
      .filter{ $0 > 0 }
      .bind { [weak self] offsetY in
        guard let self else { return }
        
        let profileEditButtonMinY: CGFloat = self.profileInfoView.frame.minY - (UIDevice().hasNotch ? 44 : 20)
        let isStickyOffset: Bool = (offsetY > profileEditButtonMinY)
        
        self.stickyNavView.isHidden = !isStickyOffset
        self.stickySuperAreaView.isHidden = !isStickyOffset
        
        self.followStatusButton.isHidden = isStickyOffset
        self.profileInfoView.isHidden = isStickyOffset
        
      }.disposed(by: disposeBag)
  }
  
  private func setUIWithFollowStatus(followStatus: Bool, targetUserName: String) {
    self.stickyNavTitleLabel.text = targetUserName
    
    self.followStatusButton.setTitle(followStatus ? "팔로잉" : "팔로우")
    self.followStatusButton.setImage(followStatus ? .DecoImage.checkColor : .DecoImage.uploadWhite)
    self.followStatusButton.backgroundColor = followStatus ? .DecoColor.lightGray1 : .DecoColor.secondaryColor
    self.followStatusButton.tintColor = followStatus ? .DecoColor.gray2 : .DecoColor.whiteColor
    
    self.stickyFollowStatusButton.setTitle(followStatus ? "팔로잉" : "팔로우")
    self.stickyFollowStatusButton.tintColor = followStatus ? .DecoColor.gray2 : .DecoColor.secondaryColor
  }
  
  // MARK: - TargetUserProfilePresentable
  
  func setUserProfileInfo(with profileInfo: ProfileDTO) {
    self.stickyNavTitleLabel.text = profileInfo.nickname
    self.followStatusButton.imageEdgeInsets = .zero
    self.followStatusButton.titleEdgeInsets = .zero
    self.followStatusButton.setTitle("프로필 수정")
    self.followStatusButton.backgroundColor = .DecoColor.secondaryColor
    self.followStatusButton.tintColor = .DecoColor.whiteColor
    
    self.stickyFollowStatusButton.setTitle("수정")
    self.stickyFollowStatusButton.tintColor = .DecoColor.gray2
    
    self.profileView.setProfile(with: profileInfo)
    self.profileInfoView.setProfileInfo(with: profileInfo)
  }
  
  func setTargetUserProfileInfo(with profileInfo: ProfileDTO) {
    self.setUIWithFollowStatus(followStatus: profileInfo.followStatus, targetUserName: profileInfo.nickname)
    self.profileView.setProfile(with: profileInfo)
    self.profileInfoView.setProfileInfo(with: profileInfo)
  }
  
  func showBlockAlert() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let blameButton = UIAlertAction(
      title: "신고하기",
      titleColor: .DecoColor.darkGray1,
      style: .default) { _ in
        print("신고하기")
      }
    
    let blockButton = UIAlertAction(
      title: "차단하기",
      titleColor: .DecoColor.darkGray1,
      style: .default) { _ in
        print("차단하기")
      }
    
    
    let cancelButton = UIAlertAction(
      title: "취소",
      titleColor: .DecoColor.warningColor,
      style: .cancel
    )
    
    alert.addActions([blameButton, blockButton, cancelButton])
    
    self.present(alert, animated: true)
  }
  
  func showUnblockAlert() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let blameButton = UIAlertAction(
      title: "신고하기",
      titleColor: .DecoColor.darkGray1,
      style: .default) { _ in
        print("신고하기")
      }
    
    let blockButton = UIAlertAction(
      title: "차단 해제",
      titleColor: .DecoColor.darkGray1,
      style: .default
    ) { _ in
      print("차단 해제")
    }
    
    let cancelButton = UIAlertAction(
      title: "취소",
      titleColor: .DecoColor.warningColor,
      style: .cancel
    )
    
    alert.addActions([blameButton, blockButton, cancelButton])
    
    self.present(alert, animated: true)
  }
  
  func showEditProfileAlert() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let editButton = UIAlertAction(
      title: "수정하기",
      titleColor: .DecoColor.darkGray1,
      style: .default) { _ in
        print("수정하기")
      }
    
    let cancelButton = UIAlertAction(
      title: "취소",
      titleColor: .DecoColor.warningColor,
      style: .cancel
    )
    
    alert.addActions([editButton, cancelButton])
    
    self.present(alert, animated: true)
  }
}
