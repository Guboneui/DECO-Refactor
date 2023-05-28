//
//  PhotoBookmarkViewController.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/29.
//

import RIBs
import RxSwift
import UIKit

protocol PhotoBookmarkPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class PhotoBookmarkViewController: UIViewController, PhotoBookmarkPresentable, PhotoBookmarkViewControllable {
  
  weak var listener: PhotoBookmarkPresentableListener?
  
  let productBookmarkLabel: UILabel = UILabel().then {
    $0.text = "photo"
    $0.textAlignment = .center
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .gray
    self.view.addSubview(productBookmarkLabel)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.productBookmarkLabel.pin
      .center()
      .size(100)
  }
}
