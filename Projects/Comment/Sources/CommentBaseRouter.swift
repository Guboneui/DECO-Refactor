//
//  CommentBaseRouter.swift
//  Comment
//
//  Created by 구본의 on 2023/07/25.
//

import Util

import RIBs

protocol CommentBaseInteractable:
  Interactable,
  CommentListener
{
  var router: CommentBaseRouting? { get set }
  var listener: CommentBaseListener? { get set }
}

protocol CommentBaseViewControllable: ViewControllable {
  func addCommentVC(_ view: ViewControllable)
}

final class CommentBaseRouter: ViewableRouter<CommentBaseInteractable, CommentBaseViewControllable>, CommentBaseRouting {
  
  private let commentBuildable: CommentBuildable
  private var commentRouting: Routing?
  
  init(
    interactor: CommentBaseInteractable,
    viewController: CommentBaseViewControllable,
    commentBuildable: CommentBuildable
  ) {
    self.commentBuildable = commentBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachCommentRIB(boardID: Int) {
    if commentRouting != nil { return }
    let router = commentBuildable.build(withListener: interactor, boardID: boardID)
    let comment = router.viewControllable
    let navigation = NavigationControllerable(root: comment)
    navigation.navigationController.navigationBar.isHidden = true
    viewController.addCommentVC(navigation)
    self.commentRouting = router
    self.attachChild(router)
  }
  
  func detachCommentRIB() {
    guard let router = commentRouting else { return }
    self.commentRouting = nil
    self.detachChild(router)
  } 
}
