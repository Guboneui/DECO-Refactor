//
//  WithdrawViewController.swift
//  AppSetting
//
//  Created by 구본의 on 2023/06/21.
//

import UIKit

import CommonUI

import RIBs
import RxCocoa
import RxSwift
import RxRelay

protocol WithdrawPresentableListener: AnyObject {
  var withdrawReason: BehaviorRelay<[String]> { get }
  func dismissWithdrawPopup()
}

final class WithdrawViewController: PopupViewController, WithdrawPresentable, WithdrawViewControllable {
  
  weak var listener: WithdrawPresentableListener?
  private var disposeBag: DisposeBag = DisposeBag()
  private var isKeyboardVisible: BehaviorRelay<Bool> = .init(value: false)
  
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "탈퇴하는 이유를 선택해 주세요 :("
    $0.textColor = .DecoColor.blackColor
    $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 14)
  }
  
  private let withdrawReasonCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.register(DefaultTextCell.self, forCellWithReuseIdentifier: DefaultTextCell.identifier)
    $0.backgroundColor = .DecoColor.whiteColor
    $0.bounces = false
  }
  
  private let cvItemHeight: CGFloat = 20.0
  private let cvLineSpacing: CGFloat = 32.0
  private let cvTopMargin: CGFloat = 18.0
  private let cvBottomMargin: CGFloat = 24.0
  private let cvLeftMargin: CGFloat = 20.0
  private var cvHeight: CGFloat = 0.0
  
  private let etcReasonBaseView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadius(radius: 12)
  }
  
  private let confirmBaseView: UIView = UIView().then {
    $0.backgroundColor = .DecoColor.whiteColor
    $0.makeCornerRadius(radius: 12)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGestures()
    self.setupWithdrawReasonCollectionView()
    self.keyboardBinding()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.disposeBag = DisposeBag()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.setupLayouts()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    baseView.makeCornerRadius(radius: 8)
    baseView.backgroundColor = .DecoColor.primaryColor
    
    baseView.addSubview(titleLabel)
    baseView.addSubview(withdrawReasonCollectionView)
  }
  
  private func setupLayouts() {
    titleLabel.pin
      .top(10)
      .horizontally(20)
      .sizeToFit(.width)
    
    withdrawReasonCollectionView.pin
      .below(of: titleLabel)
      .horizontally()
      .height(cvHeight)
      .marginTop(12)
  }
  
  private func setupGestures() {
    bgView.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        if self.isKeyboardVisible.value {
          self.view.endEditing(true)
          self.isKeyboardVisible.accept(false)
        } else {
          self.hideAnimation { [weak self] in
            guard let inSelf = self else { return }
            inSelf.listener?.dismissWithdrawPopup()
          }
        }
      }.disposed(by: disposeBag)
  }
  
  private func setupWithdrawReasonCollectionView() {
    withdrawReasonCollectionView.setupDefaultListLayout(
      cellHeight: cvItemHeight,
      groupSpacing: cvLineSpacing,
      sectionInset: NSDirectionalEdgeInsets(top: cvTopMargin, leading: cvLeftMargin, bottom: cvBottomMargin, trailing: 0.0)
    )
    
    listener?.withdrawReason
      .share()
      .bind(to: withdrawReasonCollectionView.rx.items(
        cellIdentifier: DefaultTextCell.identifier,
        cellType: DefaultTextCell.self)
      ) { [weak self] index, reason, cell in
        guard let self else { return }
        cell.setupCellConfigure(text: reason)
      }.disposed(by: disposeBag)
    
    Observable.zip(
      withdrawReasonCollectionView.rx.itemSelected,
      withdrawReasonCollectionView.rx.modelSelected(String.self)
    ).subscribe(onNext: { [weak self] index, reason in
      guard let self else { return }
      let totalCount: Int = self.listener?.withdrawReason.value.count ?? 0
      
      if index.row == totalCount - 1 {
        print("기타 이유")
        self.removeBaseView()
        self.makeInputEtcReasonView()
      } else {
        // MARK: TODO
        print("해당 이유로 탈퇴")
      }
      print(index, reason)
    }).disposed(by: disposeBag)
  }
  
  func setCvHeight(with count: Int) {
    let totalCellHeight: CGFloat = CGFloat(count) * cvItemHeight
    let totalSpacing: CGFloat = CGFloat(count-1) * cvLineSpacing
    self.cvHeight = totalCellHeight + totalSpacing + cvTopMargin + cvBottomMargin
    self.setupLayouts()
    self.view.setNeedsLayout()
  }
}

// MARK: - Make Etc View

extension WithdrawViewController {
  private func removeBaseView() {
    baseView.removeFromSuperview()
  }
  
  private func makeInputEtcReasonView() {
    let etcReasonTextField: UITextField = UITextField().then {
      $0.placeholder = "탈퇴 기타 이유를 입력해 주세요."
      $0.textColor = .DecoColor.darkGray1
      $0.tintColor = .DecoColor.darkGray1
      $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    }
    
    let cancelButton: UIButton = UIButton(type: .system).then {
      $0.setTitle("취소")
      $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
      $0.tintColor = .DecoColor.successColor
    }
    
    let confirmButton: UIButton = UIButton(type: .system).then {
      $0.setTitle("확인")
      $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
      $0.tintColor = .DecoColor.darkGray2
    }
    
    view.addSubview(etcReasonBaseView)
    etcReasonBaseView.addSubview(etcReasonTextField)
    etcReasonBaseView.addSubview(cancelButton)
    etcReasonBaseView.addSubview(confirmButton)
    
    etcReasonBaseView.pin
      .vCenter()
      .horizontally(18)
      .height(120)
    
    etcReasonTextField.pin
      .top()
      .horizontally(24)
      .height(60)
    
    cancelButton.pin
      .below(of: etcReasonTextField)
      .left()
      .right(to: etcReasonTextField.edge.hCenter)
      .height(60)
    
    confirmButton.pin
      .below(of: etcReasonTextField)
      .after(of: cancelButton)
      .right()
      .height(60)
    
    // TextField Action
    etcTextFieldAction(etcReasonTextField)
    // Button Action
    etcButtonAction(etcReasonTextField, cancelButton, confirmButton)
  }
  
  private func etcTextFieldAction(_ etcReasonTextField: UITextField) {
    self.isKeyboardVisible.accept(true)
    etcReasonTextField.becomeFirstResponder()
    
    etcReasonTextField.rx.controlEvent(.editingDidEndOnExit)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.isKeyboardVisible.accept(false)
      }).disposed(by: disposeBag)
    
    etcReasonTextField.rx.controlEvent(.editingDidBegin)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.isKeyboardVisible.accept(true)
      }).disposed(by: disposeBag)
  }
  
  private func etcButtonAction(_ etcReasonTextField: UITextField, _ cancelButton: UIButton, _ confirmButton: UIButton) {
    cancelButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        self.isKeyboardVisible.accept(false)
        UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
          guard let inSelf = self else { return }
          inSelf.etcReasonBaseView.alpha = 0.0
        }
        
        self.hideAnimation { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.dismissWithdrawPopup()
        }
      }.disposed(by: disposeBag)
    
    confirmButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        if let reason = etcReasonTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
          //print("탈퇴이유: \(reason)")
          self.isKeyboardVisible.accept(false)
          self.removeEtcBaseView()
          self.makeWithdrawConfirmView()
        }
      }.disposed(by: disposeBag)
  }
  
  private func keyboardBinding() {
    isKeyboardVisible
      .observe(on: MainScheduler.instance)
      .bind { [weak self] isVisible in
        guard let self else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          guard let inSelf = self else { return }
          inSelf.etcReasonBaseView.pin
            .vCenter(isVisible ? -40 : 0)
        })
      }.disposed(by: disposeBag)
  }
}

// MARK: Make Confirm View

extension WithdrawViewController {
  private func removeEtcBaseView() {
    etcReasonBaseView.removeFromSuperview()
  }
  
  private func makeWithdrawConfirmView() {
    let withdrawConfirmLabel: UILabel = UILabel().then {
      $0.text = "정말 탈퇴하실건가요? :("
      $0.font = .DecoFont.getFont(with: .NotoSans, type: .medium, size: 14)
      $0.textColor = .DecoColor.darkGray1
    }
    
    let noButton: UIButton = UIButton(type: .system).then {
      $0.setTitle("아니오", for: .normal)
      $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
      $0.tintColor = .DecoColor.successColor
    }
    
    let yesButton: UIButton = UIButton(type: .system).then {
      $0.setTitle("예", for: .normal)
      $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
      $0.tintColor = .DecoColor.darkGray2
    }
    
    
    view.addSubview(confirmBaseView)
    confirmBaseView.addSubview(withdrawConfirmLabel)
    confirmBaseView.addSubview(noButton)
    confirmBaseView.addSubview(yesButton)
    
    confirmBaseView.pin
      .vCenter()
      .horizontally(18)
      .height(120)
    
    withdrawConfirmLabel.pin
      .top()
      .horizontally(24)
      .height(60)
    
    noButton.pin
      .below(of: withdrawConfirmLabel)
      .left()
      .right(to: withdrawConfirmLabel.edge.hCenter)
      .height(60)
    
    yesButton.pin
      .below(of: withdrawConfirmLabel)
      .after(of: noButton)
      .right()
      .height(60)
    
    self.confirmViewButtonAction(noButton, yesButton)
  }
  
  private func confirmViewButtonAction(_ noButton: UIButton, _ yesButton: UIButton) {
    noButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        UIView.animate(withDuration: 0.15, delay: 0.0) { [weak self] in
          guard let inSelf = self else { return }
          inSelf.confirmBaseView.alpha = 0.0
        }
        self.hideAnimation { [weak self] in
          guard let inSelf = self else { return }
          inSelf.listener?.dismissWithdrawPopup()
        }
      }.disposed(by: disposeBag)
    
    yesButton.tap()
      .bind { [weak self] in
        guard let self else { return }
        print("진짜 탈퇴")
        
      }.disposed(by: disposeBag)
  }
}
