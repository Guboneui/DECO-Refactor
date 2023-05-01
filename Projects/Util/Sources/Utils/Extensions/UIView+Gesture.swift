//
//  UIView+Gesture.swift
//  Util
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit
import RxSwift
import RxGesture

public extension UIView {
  func tap() -> Observable<UITapGestureRecognizer> {
   return rx.tapGesture()
      .when(.recognized)
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
  }
}
