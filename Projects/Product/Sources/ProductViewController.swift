//
//  ProductViewController.swift
//  Product
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift
import UIKit
import Then
import PinLayout

protocol ProductPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final public class ProductViewController: UIViewController, ProductPresentable, ProductViewControllable {
  
  weak var listener: ProductPresentableListener?
  
  private let productLabel: UILabel = UILabel().then {
    $0.text = "product"
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .green
    self.view.addSubview(productLabel)
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.productLabel.pin
      .center()
      .size(100)
  }
}
