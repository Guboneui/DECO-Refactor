//
//  CommentBaseInteractor.swift
//  Comment
//
//  Created by 구본의 on 2023/07/25.
//

import RIBs
import RxSwift

public protocol CommentBaseRouting: ViewableRouting {
  
}

protocol CommentBasePresentable: Presentable {
  var listener: CommentBasePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol CommentBaseListener: AnyObject {
  func dismissCommentVC()
}

final class CommentBaseInteractor: PresentableInteractor<CommentBasePresentable>, CommentBaseInteractable, CommentBasePresentableListener {
  
  weak var router: CommentBaseRouting?
  weak var listener: CommentBaseListener?
  
  private let boardID: Int
  
  init(
    presenter: CommentBasePresentable,
    boardID: Int
  ) {
    self.boardID = boardID
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func dismissCommentVC() {
    listener?.dismissCommentVC()
  }
}
