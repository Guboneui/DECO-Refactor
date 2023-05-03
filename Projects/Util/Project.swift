//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let setting: Settings = .settings(
  base: [
    "DEVELOPMENT_TEAM": "VKGAQDGK5R"
  ],
  configurations: [],
  defaultSettings: .recommended
)

let packages: [Package] = [
  .RIBs,
  .RxSwift,
  .RxGesture
]

let dependencies: [TargetDependency] = [
  .RIBs,
  .RxSwift,
  .RxGesture
]

let util = Target(
  name: "Util",
  platform: .iOS,
  product: .staticFramework,
  productName: "Util",
  bundleId: "com.deco.ios.Util",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Util",
  packages: packages,
  targets: [util]
)
