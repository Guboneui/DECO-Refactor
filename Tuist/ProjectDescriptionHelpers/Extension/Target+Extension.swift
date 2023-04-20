//
//  Target+Extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/21.
//

import ProjectDescription

public extension Target {
  static func makeFrameworkTargets(
    name: String,
    isDynamic: Bool,
    dependencies: [TargetDependency],
    needTestTarget: Bool
  ) -> [Target] {
    var result: [Target] = []
    
    result.append(Target(
      name: name,
      platform: .iOS,
      product: isDynamic ? .framework : .staticFramework,
      productName: name,
      bundleId: "com.deco.ios.\(name)",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: dependencies
    ))
    
    if needTestTarget {
      result.append(
        Target(
          name: "\(name)Tests",
          platform: .iOS,
          product: .unitTests,
          productName: "\(name)Tests",
          bundleId: "com.deco.ios.\(name)Tests",
          deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
          infoPlist: .default,
          sources: ["Tests/**"],
          dependencies: []
        )
      )
    }
    
    return result
  }
}

