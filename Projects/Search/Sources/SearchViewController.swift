//
//  SearchViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import UIKit

import Util
import CommonUI

import RIBs
import RxSwift
import RxRelay

protocol SearchPresentableListener: AnyObject {
  
  var searchHistory: BehaviorRelay<[String]> { get }
  
  func popSearchVC(with popType: PopType)
  func pushSearchResultVC(with searchText: String)
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
  
  weak var listener: SearchPresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let navigationBar: NavigationBar = NavigationBar(
    navTitle: "",
    showGuideLine: true
  )
  
  private let searchBarView: UIView = UIView().then {
    $0.makeCornerRadius(radius: 10)
    $0.backgroundColor = .DecoColor.lightGray1
  }
  
  private let searchImageView: UIImageView = UIImageView().then {
    $0.image = .DecoImage.searchGray2
  }
  
  private let searchTextField: UITextField = UITextField().then {
    $0.placeholder = "브랜드 및 상품 검색하기"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 12)
    $0.tintColor = .DecoColor.darkGray2
    $0.textColor = .DecoColor.darkGray2
    $0.returnKeyType = .search
    $0.setClearButton(with: .DecoImage.closeFill, mode: .whileEditing)
  }
  
  private let recentSearchTextLabel: UILabel = UILabel().then {
    $0.text = "최근 검색어"
    $0.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 14)
    $0.textColor = .DecoColor.gray4
  }
  
  private let removeSearchHistoryButton: UIButton = UIButton(type: .system).then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.tintColor = .DecoColor.gray3
    $0.titleLabel?.font = .DecoFont.getFont(with: .Suit, type: .medium, size: 10)
    $0.backgroundColor = .DecoColor.lightBackground
    $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    $0.makeCornerRadius(radius: 8)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupBindings()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.searchTextField.becomeFirstResponder()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popSearchVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.navigationBar.addSubview(searchBarView)
    self.searchBarView.addSubview(searchImageView)
    self.searchBarView.addSubview(searchTextField)
    self.view.addSubview(recentSearchTextLabel)
    self.view.addSubview(removeSearchHistoryButton)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    searchBarView.pin
      .vCenter()
      .left(68)
      .right(24)
      .height(32)
    
    searchImageView.pin
      .left(20)
      .vertically(6)
      .size(20)
    
    searchTextField.pin
      .left(to: searchImageView.edge.right)
      .right(10)
      .vCenter()
      .marginLeft(20)
      .height(20)
    
    recentSearchTextLabel.pin
      .below(of: navigationBar)
      .left(30)
      .marginTop(30)
      .sizeToFit()
      
    removeSearchHistoryButton.pin
      .vCenter(to: recentSearchTextLabel.edge.vCenter)
      .right(20)
      .sizeToFit()
    
  }
  
  private func setupGestures() {
    navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popSearchVC(with: .BackButton)
    }
    
    
  }
  
  private func setupBindings() {
    searchTextField.rx.controlEvent(.editingDidEndOnExit)
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        if let text = self.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           !text.isEmpty {
          self.listener?.pushSearchResultVC(with: text)
        }
      }).disposed(by: disposeBag)
    
    listener?.searchHistory
      .compactMap{$0}
      .subscribe(onNext: { [weak self] histories in
        guard let self else { return }
        self.recentSearchTextLabel.isHidden = histories.isEmpty
        self.removeSearchHistoryButton.isHidden = histories.isEmpty
      }).disposed(by: disposeBag)
  }
}
