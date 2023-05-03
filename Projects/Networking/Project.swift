//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/05/04.
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
  .Moya
]

let dependencies: [TargetDependency] = [
  .Moya
]

let networking = Target(
  name: "Networking",
  platform: .iOS,
  product: .staticFramework,
  productName: "Networking",
  bundleId: "com.deco.ios.Networking",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Networking",
  packages: packages,
  targets: [networking]
)

