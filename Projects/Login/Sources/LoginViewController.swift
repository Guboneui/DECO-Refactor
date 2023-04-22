//
//  LoginViewController.swift
//  Login
//
//  Created by 구본의 on 2023/04/21.
//  Copyright © 2023 Boni. All rights reserved.
//

import UIKit
import CommonUI
import SnapKit



public class LoginViewController: UIViewController {
  
  let label = UILabel()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = CommonUIAsset.Color.primaryColor.color
    print("🔊[DEBUG]: Login")
    
    label.text = "asdf"
    
    self.view.addSubview(label)
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
