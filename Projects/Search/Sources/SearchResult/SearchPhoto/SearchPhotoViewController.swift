//
//  SearchPhotoViewController.swift
//  Search
//
//  Created by 구본의 on 2023/06/12.
//

import RIBs
import RxSwift
import UIKit
import CommonUI

protocol SearchPhotoPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class SearchPhotoViewController: UIViewController, SearchPhotoPresentable, SearchPhotoViewControllable {
  
  weak var listener: SearchPhotoPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .DecoColor.whiteColor
    
  }
}
