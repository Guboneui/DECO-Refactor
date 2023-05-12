//
//  ProfileViewController.swift
//  Profile
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift
import UIKit
import Then
import PinLayout

protocol ProfilePresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final public class ProfileViewController: UIViewController, ProfilePresentable, ProfileViewControllable {
  
  weak var listener: ProfilePresentableListener?
  
  private let profileLabel: UILabel = UILabel().then {
    $0.text = "Profile"
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .yellow
    self.view.addSubview(profileLabel)
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.profileLabel.pin
      .center()
      .size(100)
  }
}
