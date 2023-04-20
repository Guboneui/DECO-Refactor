//
//  Project.swift
//  DecoRefactoringManifests
//
//  Created by 구본의 on 2023/04/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName: String = "DECO"
private let iOSTargetVersion: String = "15.0"


let infoPlist: [String:InfoPlist.Value] = [
  "CFBundleShortVersionString": "1.0.0",
  "CFBundleVersion": "1",
  "UIMainStoryboardFile": "",
  "UILaunchStoryboardName": "LaunchScreen"
]

let project = Project.app(
  name: projectName,
  platform: .iOS,
  iOSTargetVersion: iOSTargetVersion,
  infoPlist: infoPlist,
  dependencies: []
)

