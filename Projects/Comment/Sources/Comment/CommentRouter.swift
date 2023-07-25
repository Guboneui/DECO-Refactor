//
//  CommentRouter.swift
//  Comment
//
//  Created by 구본의 on 2023/07/26.
//

import Util
import Entity

import RIBs

protocol CommentInteractable:
  Interactable,
  CommentDetailListener
{
  var router: CommentRouting? { get set }
  var listener: CommentListener? { get set }
}

protocol CommentViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CommentRouter: ViewableRouter<CommentInteractable, CommentViewControllable>, CommentRouting {
  
  private let commentDetailBuildable: CommentDetailBuildable
  private var commentDetailRouting: Routing?
  
  init(
    interactor: CommentInteractable,
    viewController: CommentViewControllable,
    commentDetailBuildable: CommentDetailBuildable
  ) {
    self.commentDetailBuildable = commentDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachCommentDetailRIB(boardID: Int, parentComment: CommentDTO, commentParentID: Int) {
    if commentDetailRouting != nil { return }
    let router = commentDetailBuildable.build(
      withListener: interactor,
      boardID: boardID,
      parentComment: parentComment,
      commentParentID: commentParentID
    )
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.commentDetailRouting = router
    attachChild(router) 
  }
  
  func detachCommentDetailRIB(with popType: PopType) {
    guard let router = commentDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.commentDetailRouting = nil
    self.detachChild(router)
  }
}
