//
//  ProfileEditViewController.swift
//  Profile
//
//  Created by 구본의 on 2023/05/28.
//

import UIKit

import User
import Util
import CommonUI


import RIBs
import RxSwift

protocol ProfileEditPresentableListener: AnyObject {
  func popProfileEditVC(with popType: PopType)
}

final class ProfileEditViewController: UIViewController, ProfileEditPresentable, ProfileEditViewControllable {
  
  weak var listener: ProfileEditPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "프로필 수정",
    showGuideLine: false
  )
  
  private let confirmButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("확인")
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
  }
  
  private let backgroundImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFill
  }
  
  private let backgroundGrayView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.blackColor.withAlphaComponent(0.2)
  }
  
  private let profileImageShadowView: UIView = UIView().then {
    $0.layer.shadowColor = UIColor.DecoColor.blackColor.withAlphaComponent(0.25).cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    $0.layer.shadowOpacity = 1.0
    $0.layer.shadowRadius = 4
    $0.layer.cornerRadius = 45
  }
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.makeCornerRadius(radius: 45)
    $0.image = .DecoImage.checkSec
  }
  
  private let editProfileImageButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.cameraWhite)
    $0.tintColor = .DecoColor.whiteColor
  }
  
  private let editProfileNameGuideLineView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let editProfileNamePencilImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.penWhite
  }
  
  private let editProfileNameTextField: UITextField = UITextField().then {
    $0.placeholder = "공간의 이름을 지어 주세요"
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 20)
    $0.textColor = .DecoColor.whiteColor
    $0.tintColor = .DecoColor.whiteColor
    $0.textAlignment = .center
  }
  
  private let editProfileNickNameGuideLineView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let editProfileNickNamePencilImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.penWhite
  }
  
  private let editProfileNickNameTextField: UITextField = UITextField().then {
    $0.placeholder = "닉네임을 입력해 주세요"
    $0.font = .DecoFont.getFont(with: .Suit, type: .bold, size: 16)
    $0.textColor = .DecoColor.whiteColor
    $0.tintColor = .DecoColor.whiteColor
    $0.textAlignment = .center
  }
  
  
  private let editProfileBackgroundImageButton: UIButton = UIButton(type: .system).then {
    $0.setImage(.DecoImage.cameraWhite)
    $0.tintColor = .DecoColor.whiteColor
  }
  
  
  private let descriptionPlaceHolder: String = "나를 소개하는 한마디를 작성해 보세요"
  
  private let editProfileDescriptionGuideLineView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
  }
  
  private let editProfileDescriptionPencilImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.penWhite
  }
  
  private lazy var editProfileDescriptionTextView: UITextView = UITextView().then {
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.textAlignment = .center
    $0.text = self.descriptionPlaceHolder
    $0.textColor = .DecoColor.whiteColor
    $0.tintColor = .DecoColor.whiteColor
    $0.sizeToFit()
    $0.isScrollEnabled = false
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBindings()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popProfileEditVC(with: .Swipe)
    }
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.navigationBar.addSubview(confirmButton)
    self.view.addSubview(backgroundImageView)
    self.view.addSubview(backgroundGrayView)
    self.backgroundGrayView.addSubview(profileImageShadowView)
    self.profileImageShadowView.addSubview(profileImageView)
    self.profileImageShadowView.addSubview(editProfileImageButton)
    self.backgroundGrayView.addSubview(editProfileNameGuideLineView)
    self.backgroundGrayView.addSubview(editProfileNamePencilImageView)
    self.backgroundGrayView.addSubview(editProfileNameTextField)
    self.backgroundGrayView.addSubview(editProfileNickNameGuideLineView)
    self.backgroundGrayView.addSubview(editProfileNickNamePencilImageView)
    self.backgroundGrayView.addSubview(editProfileNickNameTextField)
    self.backgroundGrayView.addSubview(editProfileBackgroundImageButton)
    self.backgroundGrayView.addSubview(editProfileDescriptionGuideLineView)
    self.backgroundGrayView.addSubview(editProfileDescriptionPencilImageView)
    self.backgroundGrayView.addSubview(editProfileDescriptionTextView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    confirmButton.pin
      .vCenter()
      .right(16)
      .sizeToFit()
    
    backgroundImageView.pin
      .below(of: navigationBar)
      .horizontally()
      .height(UIScreen.main.bounds.width)
    
    backgroundGrayView.pin
      .below(of: navigationBar)
      .horizontally()
      .height(UIScreen.main.bounds.width)
    
    profileImageShadowView.pin
      .center()
      .size(90)
      .marginBottom(15)
    
    profileImageView.pin
      .all()
    
    editProfileImageButton.pin
      .bottomRight()
      .marginBottom(-10)
      .marginRight(-6)
      
      .size(45)
    
    editProfileNameGuideLineView.pin
      .above(of: profileImageShadowView)
      .horizontally(32)
      .height(0.5)
      .marginBottom(20)
    
    editProfileNamePencilImageView.pin
      .above(of: editProfileNameGuideLineView, aligned: .right)
      .size(22)
      .marginBottom(4)
    
    editProfileNameTextField.pin
      .above(of: editProfileNameGuideLineView, aligned: .left)
      .before(of: editProfileNamePencilImageView)
      .height(30)
      .marginRight(6)
      .marginLeft(28)
      .marginBottom(4)
    
    editProfileNickNameGuideLineView.pin
      .below(of: profileImageShadowView)
      .horizontally(32)
      .height(0.5)
      .marginTop(34)
    
    editProfileNickNamePencilImageView.pin
      .above(of: editProfileNickNameGuideLineView, aligned: .right)
      .size(22)
      .marginBottom(4)
    
    editProfileNickNameTextField.pin
      .above(of: editProfileNickNameGuideLineView, aligned: .left)
      .before(of: editProfileNickNamePencilImageView)
      .height(24)
      .marginRight(6)
      .marginLeft(28)
      .marginBottom(4)
    
    editProfileBackgroundImageButton.pin
      .bottomRight(12)
      .size(45)
    
    editProfileDescriptionGuideLineView.pin
      .height(0.5)
      .horizontally(32)
      .above(of: editProfileBackgroundImageButton)
      .marginBottom(14)
    
    editProfileDescriptionPencilImageView.pin
      .above(of: editProfileDescriptionGuideLineView, aligned: .right)
      .size(22)
      .marginBottom(4)
    
    editProfileDescriptionTextView.pin
      .above(of: editProfileDescriptionGuideLineView, aligned: .left)
      .before(of: editProfileDescriptionPencilImageView)
      .height(30)
      .marginRight(6)
      .marginLeft(28)
      .marginBottom(4)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popProfileEditVC(with: .BackButton)
    }
    
    self.editProfileImageButton.tap()
      .observe(on: MainScheduler.instance)
      .bind { [weak self] in
        guard let self else { return }
        self.changeProfileImageActionSheet()
      }.disposed(by: disposeBag)
    
    self.editProfileBackgroundImageButton.tap()
      .observe(on: MainScheduler.instance)
      .bind { [weak self] in
        guard let self else { return }
        self.changeBackgroundImageActionSheet()
      }.disposed(by: disposeBag)
    
    editProfileNamePencilImageView.tap()
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        self.editProfileNameTextField.becomeFirstResponder()
      }).disposed(by: disposeBag)
    
    editProfileNickNamePencilImageView.tap()
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        self.editProfileNickNameTextField.becomeFirstResponder()
      }).disposed(by: disposeBag)

    editProfileDescriptionPencilImageView.tap()
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        self.editProfileDescriptionTextView.becomeFirstResponder()
      }).disposed(by: disposeBag)
    
    view.tap()
      .subscribe(onNext: { [weak self] _ in
        guard let self else { return }
        self.view.endEditing(true)
      }).disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    
    editProfileDescriptionTextView.rx.didBeginEditing
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.didBeginEditingDescriptionTextView()
      }).disposed(by: disposeBag)
    
    editProfileDescriptionTextView.rx.didEndEditing
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.didEndEditingDescriptionTextView()
      }).disposed(by: disposeBag)
    
    editProfileDescriptionTextView.rx.didChange
      .bind { [weak self] in
        guard let self else { return }
        self.setDescriptionTextViewAutoHeight()
      }.disposed(by: disposeBag)
  }
  
  func defaultUserProfileInfo(with userInfo: UserManagerModel) {
    self.editProfileNameTextField.text = userInfo.profileName
    self.editProfileNickNameTextField.text = userInfo.nickname
    self.backgroundImageView.loadImage(imageUrl: userInfo.backgroundUrl)
    self.profileImageView.loadImage(imageUrl: userInfo.profileUrl)
    self.editProfileDescriptionTextView.text = userInfo.profileDescription
  }
}


// MARK: - TextView funcs
extension ProfileEditViewController {
  private func didBeginEditingDescriptionTextView() {
    if self.editProfileDescriptionTextView.text == self.descriptionPlaceHolder {
      self.editProfileDescriptionTextView.text = nil
      self.editProfileDescriptionTextView.textColor = .DecoColor.whiteColor
    }
  }
  
  private func didEndEditingDescriptionTextView() {
    if self.editProfileDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      self.editProfileDescriptionTextView.text = self.descriptionPlaceHolder
      self.editProfileDescriptionTextView.textColor = UIColor.placeholderText
    }
  }
  
  private func setDescriptionTextViewAutoHeight() {
    let textViewSize = CGSize(width: self.editProfileDescriptionTextView.frame.width, height: .infinity)
    let textViewEstimatedSize = self.editProfileDescriptionTextView.sizeThatFits(textViewSize)
    
    if textViewEstimatedSize.height >= 40 {
      self.editProfileDescriptionTextView.isScrollEnabled = true
    } else {
      self.editProfileDescriptionTextView.pin.height(textViewEstimatedSize.height)
      self.editProfileDescriptionTextView.isScrollEnabled = false
    }
  }
}



// MARK: - Action Sheet

extension ProfileEditViewController {
  private func changeProfileImageActionSheet() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let albumButton = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
      print("앨범에서 선택")
    }
    albumButton.setValue(UIColor.DecoColor.darkGray1, forKey: "titleTextColor")
    
    let removeButton = UIAlertAction(title: "프로필 사진 삭제", style: .default) { _ in
      print("프로필 이미지 삭제")
    }
    removeButton.setValue(UIColor.DecoColor.darkGray1, forKey: "titleTextColor")
    
    let cancelButton = UIAlertAction(title: "취소", style: .cancel)
    cancelButton.setValue(UIColor.DecoColor.warningColor, forKey: "titleTextColor")
    
    alert.addAction(albumButton)
    alert.addAction(removeButton)
    alert.addAction(cancelButton)
    
    self.present(alert, animated: true)
  }
  
  private func changeBackgroundImageActionSheet() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let albumButton = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
      print("앨범에서 선택")
    }
    albumButton.setValue(UIColor.DecoColor.darkGray1, forKey: "titleTextColor")
    
    let defaultButton = UIAlertAction(title: "기본 이미지에서 선택", style: .default) {  _ in
      print("기본 이미지")
    }
    
    defaultButton.setValue(UIColor.DecoColor.darkGray1, forKey: "titleTextColor")
    
    let removeButton = UIAlertAction(title: "배경 사진 삭제", style: .default) { _ in
      print("삭제")
    }
    
    removeButton.setValue(UIColor.DecoColor.darkGray1, forKey: "titleTextColor")
    
    let cancelButton = UIAlertAction(title: "취소", style: .cancel)
    cancelButton.setValue(UIColor.DecoColor.warningColor, forKey: "titleTextColor")
    
    alert.addAction(albumButton)
    alert.addAction(defaultButton)
    alert.addAction(removeButton)
    alert.addAction(cancelButton)
    
    self.present(alert, animated: true)
  }
}
