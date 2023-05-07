//
//  MoodViewController.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import CommonUI
import Util
import Networking
import Entity

protocol MoodPresentableListener: AnyObject {
  var moods: BehaviorRelay<[(styleInfo: StyleModel, isSelected: Bool)]> { get }
  func update(index: Int)
  
  func popMoodVC(with popType: PopType)
  func signUpDidTap()
}

final class MoodViewController: UIViewController, MoodPresentable, MoodViewControllable {
  
  weak var listener: MoodPresentableListener?
  private let disposeBag = DisposeBag()
  private let cellSize: CGFloat = (UIScreen.main.bounds.width - 4) / 2.0
 
  private let navigationBar = NavigationBar(
    navTitle: "회원가입하기",
    showGuideLine: true
  )
  
  private let nextButton = DefaultButton(title: "다음")
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
  }
  
  private let titleSubtitleView = TitleSubtitleView()

  private lazy var moodCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {

    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 4
    layout.minimumInteritemSpacing = 4

    $0.bounces = false
    $0.isScrollEnabled = false
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
    self.setupCollectionView()
    self.setupBindings()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isMovingFromParent {
      listener?.popMoodVC(with: .Swipe)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
  // MARK: - Private Method
  private func setupViews() {
    self.view.addSubview(navigationBar)
    self.view.addSubview(nextButton)
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(titleSubtitleView)
    self.scrollView.addSubview(moodCollectionView)
  }
  
  private func setupLayouts() {
    navigationBar.pin
      .top(view.pin.safeArea)
      .horizontally()
      .sizeToFit(.width)
    
    nextButton.pin
      .bottom(view.pin.safeArea)
      .horizontally()
      .marginHorizontal(32)
      .marginBottom(UIDevice.current.hasNotch ? 34 : 43)
    
    scrollView.pin
      .below(of: navigationBar)
      .bottom(to: nextButton.edge.top)
      .horizontally()
      .marginBottom(35)
    
    titleSubtitleView.pin
      .top(76)
      .horizontally()

    let spacing: CGFloat = 4

    moodCollectionView.pin
      .below(of: titleSubtitleView)
      .bottom(to: scrollView.edge.bottom)
      .horizontally()
      .height((cellSize*3) + (spacing*2))
      .marginTop(34)
    
    scrollView.contentSize = CGSize(width: view.frame.width, height: moodCollectionView.frame.maxY)
  }
  
  private func setupGestures() {
    self.navigationBar.didTapBackButton = { [weak self] in
      guard let self else { return }
      self.listener?.popMoodVC(with: .BackButton)
    }
    
    self.nextButton.tap()
      .subscribe(onNext: { [weak self] in
        guard let self else { return }
        self.listener?.signUpDidTap()
      }).disposed(by: disposeBag)
  }
  
  private func setupBindings() {
    listener?.moods
      .map{!($0.filter{$0.isSelected}.isEmpty)}
      .bind(to: nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
  
  private func setupCollectionView() {
    listener?.moods.bind(to: moodCollectionView.rx.items(cellIdentifier: ImageCell.identifier, cellType: ImageCell.self)) { (index, data, cell) in
      cell.setupCellData(type: .SelectedType, image: data.styleInfo.image, isSelected: data.isSelected)
    }.disposed(by: disposeBag)
    
    moodCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    moodCollectionView.rx.itemSelected
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] indexPath in
        guard let self else { return }
        self.listener?.update(index: indexPath.row)
      }.disposed(by: disposeBag)
  }
  
  // MARK: - MoodPresentable
  func set(nickname: String) {
    self.titleSubtitleView.setupTitleSubtitle(
      title: "마음에 드는 무드를 1개 이상 골라주세요!",
      subTitle: "\(nickname)님의 취향에 맞는 콘텐츠를 보여드릴게요 :)"
    )
  }
}

extension MoodViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellSize, height: cellSize)
  }
}
