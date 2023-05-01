//
//  UIButton+Gesture.swift
//  Util
//
//  Created by 구본의 on 2023/05/01.
//

import UIKit
import RxSwift
import RxGesture

public extension UIButton {
  func tap() -> Observable<Void> {
    return rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
  }
}
