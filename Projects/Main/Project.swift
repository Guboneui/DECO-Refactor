//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/05/09.
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

let packages: [Package] = []

let dependencies: [TargetDependency] = [
  .project(target: "Login", path: .relativeToCurrentFile("../Login")),
  .project(target: "Home", path: .relativeToCurrentFile("../Home")),
  .project(target: "Product", path: .relativeToCurrentFile("../Product")),
  .project(target: "Bookmark", path: .relativeToCurrentFile("../Bookmark")),
  .project(target: "Profile", path: .relativeToCurrentFile("../Profile"))
]

let main = Target(
  name: "Main",
  platform: .iOS,
  product: .framework,
  productName: "Main",
  bundleId: "com.deco.ios.main",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Main",
  packages: packages,
  targets: [main]
)

