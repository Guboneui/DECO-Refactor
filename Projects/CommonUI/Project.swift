//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/04/20.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName: String = "CommonUI"
private let iOSTargetVersion: String = "15.0"


let infoPlist: [String:InfoPlist.Value] = [
  "CFBundleShortVersionString": "1.0.0",
  "CFBundleVersion": "1",
]

let project = Project.framework(
  name: projectName,
  platform: .iOS,
  iOSTargetVersion: iOSTargetVersion
)
