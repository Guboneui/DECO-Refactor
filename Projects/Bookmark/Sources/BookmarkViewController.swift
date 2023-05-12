//
//  BookmarkViewController.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/12.
//

import RIBs
import RxSwift
import UIKit
import Then
import PinLayout


public protocol BookmarkPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final public class BookmarkViewController: UIViewController, BookmarkPresentable, BookmarkViewControllable {
  
  weak var listener: BookmarkPresentableListener?
  
  private let bookmarkLabel: UILabel = UILabel().then {
    $0.text = "북마크"
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .red
    self.view.addSubview(bookmarkLabel)
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.bookmarkLabel.pin
      .center()
      .size(100)
  }
}
