//
//  HomeViewController.swift
//  Home
//
//  Created by 구본의 on 2023/05/09.
//

import RIBs
import RxSwift
import UIKit

protocol HomePresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
  
  weak var listener: HomePresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .yellow
    print("🔊[DEBUG]: Home Did Load")
  }
}
