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
    
    self.view.tap()
      .bind { [weak self] _ in
        guard let self else { return }
        print("🔊[DEBUG]: HomeViewController listener(HomePresentableListener? = \(self.listener)")
      }.disposed(by: disposeBag)
  }
}
