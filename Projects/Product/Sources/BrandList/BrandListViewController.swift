//
//  BrandListViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/13.
//

import RIBs
import RxSwift
import UIKit

protocol BrandListPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class BrandListViewController: UIViewController, BrandListPresentable, BrandListViewControllable {
  
  weak var listener: BrandListPresentableListener?
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .darkGray
  }
}
