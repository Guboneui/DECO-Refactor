//
//  BookmarkInteractor.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import RIBs
import RxSwift
import RxRelay

enum BookMarkSegmentType: String {
  case Photo = "BOARD"
  case Product = "ITEM"
}

public protocol BookmarkRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BookmarkPresentable: Presentable {
  var listener: BookmarkPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol BookmarkListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BookmarkInteractor: PresentableInteractor<BookmarkPresentable>, BookmarkInteractable, BookmarkPresentableListener {
  
  weak var router: BookmarkRouting?
  weak var listener: BookmarkListener?
  
  var currentSegmentTab: BehaviorRelay<BookMarkSegmentType> = .init(value: .Photo)
  
  override init(
    presenter: BookmarkPresentable
  ) {
    super.init(presenter: presenter)
    presenter.listener = self 
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}
