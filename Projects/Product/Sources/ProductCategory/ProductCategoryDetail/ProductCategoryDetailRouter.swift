//
//  ProductCategoryDetailRouter.swift
//  Product
//
//  Created by 구본의 on 2023/06/01.
//

import RIBs

protocol ProductCategoryDetailInteractable:
  Interactable,
  CategoryModalListener,
  MoodColorModalListener
{
  var router: ProductCategoryDetailRouting? { get set }
  var listener: ProductCategoryDetailListener? { get set }
}

protocol ProductCategoryDetailViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProductCategoryDetailRouter: ViewableRouter<ProductCategoryDetailInteractable, ProductCategoryDetailViewControllable>, ProductCategoryDetailRouting {
  
  
  private let categoryModalBuildable: CategoryModalBuildable
  private var categoryModalRouting: Routing?
  
  private let moodColorModalBuildable: MoodColorModalBuildable
  private var moodColorModalRouting: Routing?
  
  init(
    interactor: ProductCategoryDetailInteractable,
    viewController: ProductCategoryDetailViewControllable,
    categoryModalBuildable: CategoryModalBuildable,
    moodColorModalBuildable: MoodColorModalBuildable
  ) {
    self.categoryModalBuildable = categoryModalBuildable
    self.moodColorModalBuildable = moodColorModalBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachCategoryModalVC() {
    if categoryModalRouting != nil { return }
    let router = categoryModalBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    categoryModalRouting = router
  }
  
  func detachCategoryModalVC() {
    guard let router = categoryModalRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    categoryModalRouting = nil
  }
  
  func attachMoodColorModalVC() {
    if moodColorModalRouting != nil { return }
    let router = moodColorModalBuildable.build(withListener: interactor)
    attachChild(router)
    router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(router.viewControllable, animated: false, completion: nil)
    moodColorModalRouting = router
  }
  
  func detachMoodColorModalVC() {
    guard let router = moodColorModalRouting else { return }
    detachChild(router)
    viewControllable.dismiss(animated: false, completion: nil)
    moodColorModalRouting = nil
  }
}
