//
//  ProductCategoryViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs
import RxSwift
import UIKit

protocol ProductCategoryPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class ProductCategoryViewController: UIViewController, ProductCategoryPresentable, ProductCategoryViewControllable {
  
  weak var listener: ProductCategoryPresentableListener?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .link
  }
}
