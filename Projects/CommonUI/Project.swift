//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName: String = "CommonUI"

let setting: Settings = .settings(
  base: [
    "GCC_PREPROCESSOR_DEFINITIONS" : "FLEXLAYOUT_SWIFT_PACKAGE=1",
    "DEVELOPMENT_TEAM": "VKGAQDGK5R"
  ],
  configurations: [],
  defaultSettings: .recommended
)

let packages: [Package] = [
  .FlexLayout,
  .PinLayout,
  .Then
]

let dependencies: [TargetDependency] = [
  .FlexLayout,
  .PinLayout,
  .Then
]

let commonUI = Target(
  name: projectName,
  platform: .iOS,
  product: .framework,
  productName: projectName,
  bundleId: "com.deco.ios.\(projectName)",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: projectName,
  packages: packages,
  targets: [commonUI]
)
