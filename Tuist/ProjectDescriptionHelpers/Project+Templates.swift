import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
  
  
  /// Helper function to create a framework target and an associated unit test target
  private static func makeFrameworkTarget(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    isDynamic: Bool,
    dependencies: [TargetDependency]
  ) -> [Target] {
    let sources = Target(name: name,
                         platform: platform,
                         product: isDynamic ? .framework : .staticFramework,
                         bundleId: "come.deco.ios.\(name)",
                         deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
                         infoPlist: .default,
                         sources: ["Sources/**"],
                         resources: ["Resources/**"],
                         dependencies: [])
    
    return [sources]
  }
  
  /// Helper function to create the application target and the unit test target.
  private static func makeAppTargets(
    name: String,
    platform: Platform,
    iOSTargetVersion: String,
    infoPlist: [String: InfoPlist.Value],
    dependencies: [TargetDependency]
  ) -> [Target] {
    let platform: Platform = platform
    let infoPlist: [String: InfoPlist.Value] = [
      "CFBundleShortVersionString": "1.0",
      "CFBundleVersion": "1",
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen"
    ]
    
    let additionalSetting: [String:SettingValue] = [:]
    
    let baseSetting: [String:SettingValue] = [
      "DEVELOPMENT_TEAM": "VKGAQDGK5R",
    ]
    
    let mainTarget = Target(
      name: name,
      platform: platform,
      product: .app,
      bundleId: "come.deco.ios.\(name)",
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: dependencies,
      settings: .settings(
        base: baseSetting.merging(additionalSetting, uniquingKeysWith: { first, _ in first }),
        configurations: [],
        defaultSettings: .recommended
      )
    )
    
    
    return [mainTarget]
  }
  
  private static let organizationName = "Boni"
  
  public static func app(name: String,
                         platform: Platform,
                         iOSTargetVersion: String,
                         infoPlist: [String: InfoPlist.Value],
                         dependencies: [TargetDependency] = []) -> Project {
    let targets = makeAppTargets(name: name,
                                 platform: platform,
                                 iOSTargetVersion: iOSTargetVersion,
                                 infoPlist: infoPlist,
                                 dependencies: dependencies)
    return Project(name: name,
                   organizationName: organizationName,
                   targets: targets)
  }
  
  public static func frameworkWithTestApp(name: String,
                                          platform: Platform,
                                          iOSTargetVersion: String,
                                          isDynamic: Bool,
                                          infoPlist: [String: InfoPlist.Value] = [:],
                                          dependencies: [TargetDependency] = []) -> Project {
    var targets = makeFrameworkTarget(name: name,
                                      platform: platform,
                                      iOSTargetVersion: iOSTargetVersion,
                                      isDynamic: isDynamic,
                                      dependencies: dependencies)
    targets.append(contentsOf: makeAppTargets(name: "\(name)TestApp",
                                              platform: platform,
                                              iOSTargetVersion: iOSTargetVersion,
                                              infoPlist: infoPlist,
                                              dependencies: [.target(name: name)]))
    
    return Project(name: name,
                   organizationName: organizationName,
                   targets: targets)
  }
  
  public static func framework(name: String,
                               platform: Platform,
                               iOSTargetVersion: String,
                               isDynamic: Bool,
                               packages: [Package] = [],
                               dependencies: [TargetDependency] = []) -> Project {
    let targets = makeFrameworkTarget(name: name,
                                      platform: platform,
                                      iOSTargetVersion: iOSTargetVersion,
                                      isDynamic: isDynamic,
                                      dependencies: dependencies)
    return Project(name: name,
                   organizationName: organizationName,
                   packages: packages,
                   targets: targets)
  }
}
