//
//  NickNameViewController.swift
//  Login
//
//  Created by 구본의 on 2023/04/24.
//

import RIBs
import RxSwift
import UIKit

protocol NickNamePresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class NickNameViewController: UIViewController, NickNamePresentable, NickNameViewControllable {
  
  weak var listener: NickNamePresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .blue
  }
}
