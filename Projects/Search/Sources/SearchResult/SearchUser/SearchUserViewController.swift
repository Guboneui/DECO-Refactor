//
//  SearchUserViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import UIKit

import CommonUI

import RIBs
import RxSwift


protocol SearchUserPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class SearchUserViewController: UIViewController, SearchUserPresentable, SearchUserViewControllable {
  
  weak var listener: SearchUserPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
  }
}
