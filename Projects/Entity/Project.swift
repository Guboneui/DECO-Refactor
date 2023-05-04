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

let packages: [Package] = []

let dependencies: [TargetDependency] = []

let entity = Target(
  name: "Entity",
  platform: .iOS,
  product: .framework,
  productName: "Entity",
  bundleId: "com.deco.ios.Entity",
  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
  infoPlist: .default,
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  dependencies: dependencies,
  settings: setting
)

let project = Project(
  name: "Entity",
  packages: packages,
  targets: [entity]
)


