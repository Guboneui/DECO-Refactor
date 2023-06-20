//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/06/20.
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

  .project(target: "User", path: "../User")
  
]

let appSetting = Target(
  name: "AppSetting",
  platform: .iOS,
  product: .framework,
  productName: "AppSetting",
  bundleId: "com.deco.ios.appSetting",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "AppSetting",
  packages: packages,
  targets: [appSetting]
)





