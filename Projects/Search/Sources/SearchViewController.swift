//
//  SearchViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/11.
//

import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .yellow
  }
}
