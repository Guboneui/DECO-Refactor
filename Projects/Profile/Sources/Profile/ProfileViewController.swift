//
//  ProfileViewController.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import UIKit

import CommonUI

import Then
import PinLayout
import RIBs
import RxSwift

protocol ProfilePresentableListener: AnyObject {
}

final public class ProfileViewController: UIViewController, ProfilePresentable, ProfileViewControllable {
  
  weak var listener: ProfilePresentableListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.bounces = false
  }
  
  private let profileView: ProfileView = ProfileView()
  
  private let profileEditButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("프로필 수정", for: .normal)
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 14)
    $0.tintColor = .DecoColor.whiteColor
    $0.backgroundColor = .DecoColor.secondaryColor
  }
  
  private let profileInfoView: ProfileInfoView = ProfileInfoView()
  
  private let userPostingCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.backgroundColor = .cyan
  }
  
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
    
    scrollView.rx.contentOffset
      .map { $0.y }
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
  
  
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(profileView)
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
      .top(UIDevice().hasNotch ? -47 : -20)
      .horizontally()
      .height(UIScreen.main.bounds.width)
    
    profileEditButton.pin
      .below(of: profileView)
      .horizontally()
      .height(44)
    
    profileInfoView.pin
      .below(of: profileEditButton)
      .horizontally()
      .height(52)
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height - 96
    
    userPostingCollectionView.pin
      .below(of: profileInfoView)
      .horizontally()
      .height(screenHeight)
      
    
    scrollView.contentSize = CGSize(
      width: view.frame.width,
      height: userPostingCollectionView.frame.maxY
    )
    
    // StickyHeaderView
    
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
}
