//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName: String = "Util"
private let iOSTargetVersion: String = "15.0"

let project = Project.framework(
  name: projectName,
  platform: .iOS,
  iOSTargetVersion: "15.0",
  isDynamic: true,
  packages: [
//    .RIBs
  ],
  dependencies: [
//    .RIBs,
//    .RxSwift,
  ]
)

//import ProjectDescription
//import ProjectDescriptionHelpers
//
//let setting: Settings = .settings(
//  base: [
//    "DEVELOPMENT_TEAM": "VKGAQDGK5R",
//    "OTHER_LDFLAGS": "-ObjC"
//  ],
//  configurations: [],
//  defaultSettings: .recommended
//)
//
//let packages: [Package] = [
//  .RIBs
//]
//
//let dependencies: [TargetDependency] = [
//  .RIBs
//]
//
//let util = Target(
//  name: "Util",
//  platform: .iOS,
//  product: .staticFramework,
//  productName: "Util",
//  bundleId: "com.deco.ios.Util",
//  deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
//  infoPlist: .default,
//  sources: ["Sources/**"],
//  resources: ["Resources/**"],
//  dependencies: dependencies,
//  settings: setting
//)
//
//let project = Project(
//  name: "util",
//  packages: packages,
//  targets: [util]
//)
