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

  .project(target: "AppSetting", path: "../AppSetting")
  
]

let profile = Target(
  name: "Profile",
  platform: .iOS,
  product: .framework,
  productName: "Profile",
  bundleId: "com.deco.ios.profile",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Profile",
  packages: packages,
  targets: [profile]
)




