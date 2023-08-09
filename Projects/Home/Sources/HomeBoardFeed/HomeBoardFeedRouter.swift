//
//  HomeBoardFeedRouter.swift
//  Home
//
//  Created by 구본의 on 2023/07/25.
//

import User
import Util
import Entity
import Comment
import ProductDetail

import RIBs

protocol HomeBoardFeedInteractable:
  Interactable,
  TargetUserProfileListener,
  CommentBaseListener,
  ProductDetailListener
{
  var router: HomeBoardFeedRouting? { get set }
  var listener: HomeBoardFeedListener? { get set }
}

protocol HomeBoardFeedViewControllable: ViewControllable {

}

final class HomeBoardFeedRouter: ViewableRouter<HomeBoardFeedInteractable, HomeBoardFeedViewControllable>, HomeBoardFeedRouting {
  
  private let targetUserProfileBuildable: TargetUserProfileBuildable
  private var targetUserProfileRouting: Routing?
  
  private let commentBaseBuildable: CommentBaseBuildable
  private var commentBaseRouting: Routing?
  
  private let productDetailBuildable: ProductDetailBuildable
  private var productDetailRouting: ProductDetailRouting?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: HomeBoardFeedInteractable,
    viewController: HomeBoardFeedViewControllable,
    targetUserProfileBuildable: TargetUserProfileBuildable,
    commentBaseBuildable: CommentBaseBuildable,
    productDetailBuildable: ProductDetailBuildable
  ) {
    self.targetUserProfileBuildable = targetUserProfileBuildable
    self.commentBaseBuildable = commentBaseBuildable
    self.productDetailBuildable = productDetailBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTargetUserProfileVC(with targetUserInfo: UserDTO) {
    if targetUserProfileRouting != nil { return }
    let router = targetUserProfileBuildable.build(withListener: interactor, targetUserInfo: targetUserInfo)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.targetUserProfileRouting = router
    attachChild(router)
  }
  
  func detachTargetUserProfileVC(with popType: PopType) {
    guard let router = targetUserProfileRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.targetUserProfileRouting = nil
    self.detachChild(router)
  }
  
  func attachCommentBaseRIB(with boardID: Int) {
    if commentBaseRouting != nil { return }
    let router = commentBaseBuildable.build(withListener: interactor, boardID: boardID)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    self.commentBaseRouting = router
    attachChild(router)
  }
  
  func detachCommentBaseRIB() {
    guard let router = commentBaseRouting else { return }
    viewControllable.dismiss(animated: false, completion: nil)
    self.commentBaseRouting = nil
    self.detachChild(router)
  }
  
  func attachProductDetailVC(with productInfo: ProductDTO) {
    if productDetailRouting != nil { return }
    let router = productDetailBuildable.build(withListener: interactor, productInfo: productInfo)
    self.viewControllable.pushViewController(router.viewControllable, animated: true)
    self.productDetailRouting = router
    attachChild(router)
  }
  
  func detachProductDetailVC(with popType: PopType) {
    guard let router = productDetailRouting else { return }
    if popType == .BackButton {
      self.viewControllable.popViewController(animated: true)
    }
    self.productDetailRouting = nil
    self.detachChild(router)
  }
}
