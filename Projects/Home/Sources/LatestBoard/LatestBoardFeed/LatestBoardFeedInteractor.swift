//
//  LatestBoardFeedInteractor.swift
//  Home
//
//  Created by 구본의 on 2023/07/20.
//

import Util
import Entity

import RIBs
import RxSwift
import RxRelay

protocol LatestBoardFeedRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LatestBoardFeedPresentable: Presentable {
  var listener: LatestBoardFeedPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol LatestBoardFeedListener: AnyObject {
  func popLatestBoardFeedVC(with popType: PopType)
}

final class LatestBoardFeedInteractor: PresentableInteractor<LatestBoardFeedPresentable>, LatestBoardFeedInteractable, LatestBoardFeedPresentableListener {
  
  weak var router: LatestBoardFeedRouting?
  weak var listener: LatestBoardFeedListener?
  private let disposeBag: DisposeBag = DisposeBag()
  
  var latestBoardList: BehaviorRelay<[PostingDTO]> = .init(value: [])
  
  private let boardListStream: MutableBoardStream
  
  init(
    presenter: LatestBoardFeedPresentable,
    boardListStream: MutableBoardStream
  ) {
    self.boardListStream = boardListStream
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    boardListStream.boardList
      .subscribe(onNext: { [weak self] list in
        self?.latestBoardList.accept(list)
      }).disposed(by: disposeBag)
    
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func popLatestBoardFeedVC(with popType: PopType) {
    listener?.popLatestBoardFeedVC(with: popType)
  }
}
