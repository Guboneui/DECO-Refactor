//
//  Dictionary+Extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/21.
//

import Foundation
import ProjectDescription

extension SettingsDictionary {
  public static func merging(_ targets: [Key:Value]...) -> SettingsDictionary {
    return targets.reduce([:]) { prev, target in
      return prev.merging(target, uniquingKeysWith: { return $1 })
    }
  }
}
