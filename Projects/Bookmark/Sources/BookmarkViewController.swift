//
//  BookmarkViewController.swift
//  Bookmark
//
//  Created by 구본의 on 2023/05/28.
//

import RIBs
import RxSwift
import UIKit

protocol BookmarkPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BookmarkViewController: UIViewController, BookmarkPresentable, BookmarkViewControllable {

    weak var listener: BookmarkPresentableListener?
}
