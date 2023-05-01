//
//  MoodViewController.swift
//  Login
//
//  Created by 구본의 on 2023/05/01.
//

import RIBs
import RxSwift
import UIKit
import CommonUI

protocol MoodPresentableListener: AnyObject {
  func popMoodVC()
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
  
  private let titleSubtitleView = TitleSubtitleView(
    title: "마음에 드는 무드를 1개 이상 골라주세요!",
    subTitle: "00님의 취향에 맞는 콘텐츠를 보여드릴게요 :)"
  )

  private lazy var moodCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {

    $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    $0.delegate = self
    $0.dataSource = self

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 4
    layout.minimumInteritemSpacing = 4

    $0.bounces = false
    $0.isScrollEnabled = false
    $0.collectionViewLayout = layout
    $0.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    self.setupViews()
    self.setupGestures()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.setupLayouts()
  }
  
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
      self.listener?.popMoodVC()
    }
  }
}

extension MoodViewController:
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout
{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
    cell.setupCellData(type: .SelectedType, isSelected: indexPath.row % 2 == 0 ? true : false)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellSize, height: cellSize)
  }
}
