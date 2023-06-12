//
//  SearchProductViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs
import RxSwift
import UIKit

protocol SearchProductPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class SearchProductViewController: UIViewController, SearchProductPresentable, SearchProductViewControllable {
  
  weak var listener: SearchProductPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor 
  }
}
