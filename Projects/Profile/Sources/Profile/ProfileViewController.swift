//
//  ProfileViewController.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import UIKit

import CommonUI
import Entity

import Then
import PinLayout
import RIBs
import RxSwift
import RxRelay

protocol ProfilePresentableListener: AnyObject {
  var userPostings: BehaviorRelay<[PostingDTO]> { get }
  func fetchUserPostings(id: Int, userID: Int, createdAt: Int)
  
  func pushAppSettingVC()
}

final public class ProfileViewController: UIViewController, ProfilePresentable, ProfileViewControllable {
  
  weak var listener: ProfilePresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.bounces = false
  }
  
  private let profileView: ProfileView = ProfileView()
  private let settingButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.setting, for: .normal)
    $0.tintColor = .white
  }
  
  private let profileEditButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("프로필 수정", for: .normal)
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.tintColor = .DecoColor.whiteColor
    $0.backgroundColor = .DecoColor.secondaryColor
  }
  
  private let profileInfoView: ProfileInfoView = ProfileInfoView()
  
  private let userPostingCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .DecoColor.whiteColor
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    $0.collectionViewLayout = layout
    
    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.bounces = false
    $0.isScrollEnabled = false
  }
  
  private var userPostingCollectionViewHeight: CGFloat = 0.0
  private var topMargin: CGFloat = 0.0
  
  private let stickyNavTitleLabel: UILabel = UILabel().then {
    $0.text = "TITLE"
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textAlignment = .center
    $0.backgroundColor = .DecoColor.whiteColor
    $0.isHidden = true
  }
  
  private let stickyProfileInfoView: ProfileInfoView = ProfileInfoView().then {
    $0.isHidden = true
  }
  
  private let stickySuperAreaView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.isHidden = true
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupBinds()
    self.setupGestures()
    self.setupProfilePostingCollectionView()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(profileView)
    self.profileView.addSubview(settingButton)
    self.scrollView.addSubview(profileEditButton)
    self.scrollView.addSubview(profileInfoView)
    self.scrollView.addSubview(userPostingCollectionView)
    self.view.addSubview(stickyNavTitleLabel)
    self.view.addSubview(stickyProfileInfoView)
    self.view.addSubview(stickySuperAreaView)
  }
  
  private func setupLayouts() {
    scrollView.pin.all()
    
    profileView.pin
      .top(topMargin)
      .horizontally()
      .height(UIScreen.main.bounds.width)
    
    settingButton.pin
      .topRight()
      .size(35)
      .marginTop(UIDevice.current.hasNotch ? 48 : 20)
      .marginRight(16)
    
    profileEditButton.pin
      .below(of: profileView)
      .horizontally()
      .height(44)
    
    profileInfoView.pin
      .below(of: profileEditButton)
      .horizontally()
      .height(52)
    
    userPostingCollectionView.pin
      .below(of: profileInfoView)
      .horizontally()
      .height(userPostingCollectionViewHeight)
      .marginTop(1)
      
    
    scrollView.contentSize = CGSize(
      width: view.frame.width,
      height: userPostingCollectionView.frame.maxY
    )
    
    stickyNavTitleLabel.pin
      .top(view.pin.safeArea)
      .horizontally()
      .height(44)
    
    stickyProfileInfoView.pin
      .below(of: stickyNavTitleLabel)
      .horizontally()
      .height(52)
    
    stickySuperAreaView.pin
      .top()
      .horizontally()
      .above(of: stickyNavTitleLabel)
  }
  
  private func setupProfilePostingCollectionView() {
    self.listener?.userPostings
      .observe(on: MainScheduler.instance)
      .filter{!$0.isEmpty}
      .share()
      .bind { [weak self] in
        guard let self else { return }
        let cellHeight: CGFloat = (UIScreen.main.bounds.width - 5.0) / 2
        let lineCount: Int = Int(ceil(Double($0.count) / 2.0))
        let collectionViewHeight: CGFloat = (cellHeight + 5.0) * CGFloat(lineCount)
        self.userPostingCollectionViewHeight = collectionViewHeight
        self.topMargin = UIDevice().hasNotch ? -47 : -20
        self.setupLayouts()
      }.disposed(by: disposeBag)
    
    self.listener?.userPostings
      .share()
      .bind(to: userPostingCollectionView.rx.items(
        cellIdentifier: ImageCell.identifier,
        cellType: ImageCell.self)
      ) { (index, data, cell) in
        cell.setupCellData(type: .DefaultType, imageURL: data.imageUrl ?? "")
      }.disposed(by: disposeBag)
    
    self.userPostingCollectionView.rx.willDisplayCell
      .map{$0.at}
      .subscribe(onNext: { [weak self] indexPath in
        guard let self else { return }
        
        if let potings = self.listener?.userPostings.value,
           potings.count - 1 == indexPath.row,
           let lastCreatedAt = potings[indexPath.row].createdAt {
          self.listener?.fetchUserPostings(id: 72, userID: 72, createdAt: lastCreatedAt)
        }
      }).disposed(by: disposeBag)
    
    
    self.userPostingCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
  }
  
  private func setupBinds() {
    scrollView.rx.contentOffset
      .map { $0.y }
      .filter{ $0 > 0 }
      .bind { [weak self] offsetY in
        guard let self else { return }
        
        let profileEditButtonMinY: CGFloat = self.profileEditButton.frame.minY - (UIDevice().hasNotch ? 44 : 20)
        let isStickyOffset: Bool = (offsetY > profileEditButtonMinY)
        
        self.stickyNavTitleLabel.isHidden = !isStickyOffset
        self.stickySuperAreaView.isHidden = !isStickyOffset
        self.stickyProfileInfoView.isHidden = !isStickyOffset
        
        self.profileEditButton.isHidden = isStickyOffset
        self.profileInfoView.isHidden = isStickyOffset
        
      }.disposed(by: disposeBag)
    
    
    profileEditButton.rx.tap
      .bind {
        print("aksdjfa;l")
      }.disposed(by: disposeBag)
    
  }
  
  private func setupGestures() {
    self.settingButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.listener?.pushAppSettingVC()
      }.disposed(by: disposeBag)
  }
  
  func setUserProfile(with profileInfo: ProfileDTO) {
    self.stickyNavTitleLabel.text = profileInfo.nickname
    self.profileView.setProfile(with: profileInfo)
    self.profileInfoView.setProfileInfo(with: profileInfo)
    self.stickyProfileInfoView.setProfileInfo(with: profileInfo)
  }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size: CGFloat = (UIScreen.main.bounds.width - 5.0) / 2.0
    return CGSize(width: size, height: size)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 5.0
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 5.0
  }
}
