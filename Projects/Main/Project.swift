//
//  Project.swift
//  DecoRefactoringManifests
//
//  Created by 구본의 on 2023/04/20.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

private let projectName: String = "DECO"
private let organizationName = "boni"
private let iOSTargetVersion: String = "15.0"
private let buildVersion: String = "1.0.3"
private let buildNumber: String = {
  let now = Date()
  let dataFormatter = DateFormatter()
  dataFormatter.dateFormat = "YYMMddHHmm"
  return "\(dataFormatter.string(from: now))009"
}()
private let bundleId: String = "come.deco.ios.\(projectName)"


let infoPlist: [String:InfoPlist.Value] = [
  "CFBundleShortVersionString": "1.0.0",
  "CFBundleVersion": "1",
  "UIMainStoryboardFile": "",
  "UILaunchStoryboardName": "LaunchScreen"
]

//let project = Project.app(
//  name: projectName,
//  platform: .iOS,
//  iOSTargetVersion: iOSTargetVersion,
//  infoPlist: infoPlist,
//  dependencies: [
//    .project(target: "CommonUI", path: .relativeToCurrentFile("../CommonUI"))
//  ]
//)

public var baseSettings: [String: SettingValue] = [
  "CURRENT_PROJECT_VERSION": "\(buildNumber)", // 빌드
  "MARKETING_VERSION": "\(buildVersion)", // 버전
  "DEVELOPMENT_TEAM": "VKGAQDGK5R",
  "INFOPLIST_KEY_CFBundleDisplayName": "DECO",
  "ENABLE_BITCODE": "NO",
  "CODE_SIGN_STYLE": "Automatic",
  "OTHER_LDFLAGS": "-ObjC"
]

public let settings: Settings = .settings(
  base: baseSettings,
  configurations: [
    .debug(name: "Debug"),
    .release(name: "Release")
  ]
)

let appTarget = Target(
    name: "\(projectName)",
    platform: .iOS,
    product: .app,
    bundleId: bundleId,
    deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
      .project(target: "CommonUI", path: .relativeToCurrentFile("../CommonUI"))
    ],
    settings: settings,
    environment: ["OS_ACTIVITY_MODE": "disable"] // 불필요 로그 제거
)

let project = Project(
  name: projectName,
  organizationName: organizationName,
  options: .options(
    developmentRegion: "ko",
    textSettings: .textSettings(usesTabs: true, indentWidth: 2, tabWidth: 2)
  ),
  settings: settings,
  targets: [appTarget]
)
