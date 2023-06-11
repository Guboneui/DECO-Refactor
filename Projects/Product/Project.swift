//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/05/12.
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
//  .project(target: "CommonUI", path: "../CommonUI"),
  .project(target: "User", path: "../User"),
  .project(target: "Search", path: "../Search"),
//  .project(target: "Networking", path: "../Networking")
]

let product = Target(
  name: "Product",
  platform: .iOS,
  product: .framework,
  productName: "Product",
  bundleId: "com.deco.ios.product",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Product",
  packages: packages,
  targets: [product]
)


