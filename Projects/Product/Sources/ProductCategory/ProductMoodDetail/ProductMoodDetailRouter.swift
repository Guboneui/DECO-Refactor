//
//  ProductMoodDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import RIBs

protocol ProductMoodDetailInteractable:
  Interactable,
  MoodModalListener,
  CategoryColorModalListener
{
  var router: ProductMoodDetailRouting? { get set }
  var listener: ProductMoodDetailListener? { get set }
}

protocol ProductMoodDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductMoodDetailRouter: ViewableRouter<ProductMoodDetailInteractable, ProductMoodDetailViewControllable>, ProductMoodDetailRouting {
  
  private let moodModalBuildable: MoodModalBuildable
  private var moodModalRouting: Routing?
  
  private let categoryColorModalBuildable: CategoryColorModalBuildable
  private var categoryColorModalRouting: Routing?
  
  init(
    interactor: ProductMoodDetailInteractable,
    viewController: ProductMoodDetailViewControllable,
    moodModalBuildable: MoodModalBuildable,
    categoryColorModalBuildable: CategoryColorModalBuildable
  ) {
    self.moodModalBuildable = moodModalBuildable
    self.categoryColorModalBuildable = categoryColorModalBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachMoodModalVC() {
    if moodModalRouting != nil { return }
    let router = moodModalBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    moodModalRouting = router
  }
  
  func detachMoodModalVC() {
    guard let router = moodModalRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    moodModalRouting = nil
  }
  
  func attachCategoryColorModalVC() {
    if categoryColorModalRouting != nil { return }
    let router = categoryColorModalBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    categoryColorModalRouting = router
  }
  
  func detachCategoryColorModalVC() {
    guard let router = categoryColorModalRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    categoryColorModalRouting = nil
  }
}
