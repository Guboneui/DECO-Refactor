//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

//private let projectName: String = "Login"
//private let iOSTargetVersion: String = "15.0"
//
//let project = Project.framework(
//  name: projectName,
//  platform: .iOS,
//  iOSTargetVersion: "15.0",
//  isDynamic: true,
//  dependencies: [
//    .project(target: "CommonUI", path: .relativeToCurrentFile("../CommonUI"))
//  ]
//)

let setting: Settings = .settings(
  base: [
    "DEVELOPMENT_TEAM": "VKGAQDGK5R",
    "OTHER_LDFLAGS": "-ObjC"
  ],
  configurations: [],
  defaultSettings: .recommended
)

let login = Target(
  name: "Login",
  platform: .iOS,
  product: .staticFramework,
  productName: "Login",
  bundleId: "com.deco.ios.login",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: [
    .project(target: "CommonUI", path: "../CommonUI")
  ],
  settings: setting
)

let project = Project(
  name: "Login",
  packages: [],
  targets: [login]
)
