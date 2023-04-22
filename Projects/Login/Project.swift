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
    "DEVELOPMENT_TEAM": "VKGAQDGK5R",
    "OTHER_LDFLAGS": "-ObjC"
  ],
  configurations: [],
  defaultSettings: .recommended
)

let packages: [Package] = [
  .SnapKit
]

let dependencies: [TargetDependency] = [
  .project(target: "CommonUI", path: "../CommonUI"),
  .SnapKit
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
