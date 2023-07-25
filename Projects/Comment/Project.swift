//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/07/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let setting: Settings = .settings(
  base: [
    "GCC_PREPROCESSOR_DEFINITIONS" : "FLEXLAYOUT_SWIFT_PACKAGE=1",
    "DEVELOPMENT_TEAM": "VKGAQDGK5R"
  ],
  configurations: [],
  defaultSettings: .recommended
)

let packages: [Package] = [
]

let dependencies: [TargetDependency] = [
  .project(target: "User", path: "../User"),
  .project(target: "Util", path: "../Util"),
  .project(target: "CommonUI", path: "../CommonUI"),
  .project(target: "Networking", path: "../Networking")
]

let comment = Target(
  name: "Comment",
  platform: .iOS,
  product: .framework,
  productName: "Comment",
  bundleId: "com.deco.ios.comment",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Comment",
  packages: packages,
  targets: [comment]
)






