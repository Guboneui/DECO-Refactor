//
//  Project+Extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/21.
//

import ProjectDescription

public extension Project {
  static func makeFrameworkProject(
    name: String,
    baseSetting: SettingsDictionary = [:],
    isDynamic: Bool,
    dependencies: [TargetDependency],
    needTestTarget: Bool
  ) -> Project {
    return Project(
      name: name,
      organizationName: "boni",
      settings: .settings(base: baseSetting, configurations: [], defaultSettings: .recommended),
      targets: Target.makeFrameworkTargets(
        name: name,
        isDynamic: isDynamic,
        dependencies: dependencies,
        needTestTarget: needTestTarget
      )
    )
  }
}
