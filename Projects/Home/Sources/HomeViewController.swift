//
//  HomeViewController.swift
//  Home
//
//  Created by 구본의 on 2023/05/11.
//

import RIBs
import RxSwift
import UIKit
import Util

protocol HomePresentableListener: AnyObject {
}

final public class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
  
  weak var listener: HomePresentableListener?
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .orange
   
  }
}
