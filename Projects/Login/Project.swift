//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/21.
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
//  .project(target: "Util", path: "../Util"),
//  .project(target: "Networking", path: "../Networking"),
  .project(target: "User", path: "../User"),
]

let login = Target(
  name: "Login",
  platform: .iOS,
  product: .framework,
  productName: "Login",
  bundleId: "com.deco.ios.login",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Login",
  packages: packages,
  targets: [login]
)
