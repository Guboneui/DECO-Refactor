//
//  ProductBookmarkViewController.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import UIKit

import RIBs
import RxSwift
import PinLayout

protocol ProductBookmarkPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class ProductBookmarkViewController: UIViewController, ProductBookmarkPresentable, ProductBookmarkViewControllable {
  
  weak var listener: ProductBookmarkPresentableListener?
  
  let productBookmarkLabel: UILabel = UILabel().then {
    $0.text = "Product"
    $0.textAlignment = .center
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .lightGray
    self.view.addSubview(productBookmarkLabel)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.productBookmarkLabel.pin
      .center()
      .size(100)
  }
}
