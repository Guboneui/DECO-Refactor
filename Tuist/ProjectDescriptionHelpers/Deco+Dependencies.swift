import ProjectDescription

public extension TargetDependency {
  static let Moya: TargetDependency = .package(product: "Moya")
  static let Nuke: TargetDependency = .package(product: "Nuke")
  static let Then: TargetDependency = .package(product: "Then")
  static let SnapKit: TargetDependency = .package(product: "SnapKit")
  static let SkeletonView: TargetDependency = .package(product: "SkeletonView")
  static let CryptoSwift: TargetDependency = .package(product: "CryptoSwift")
  static let Swing_Design_System: TargetDependency = .package(product: "Swing_Design_System")
  static let FirebaseAnalytics: TargetDependency = .package(product: "FirebaseAnalytics")
  static let FirebaseCrashlytics: TargetDependency = .package(product: "FirebaseCrashlytics")
  static let RxSwift: TargetDependency = .package(product: "RxSwift")
  static let RxGesture: TargetDependency = .package(product: "RxGesture")
  static let RIBs: TargetDependency = .package(product: "RIBs")
  static let FlexLayout: TargetDependency = .package(product: "FlexLayout")
  static let PinLayout: TargetDependency = .package(product: "PinLayout")
  static let Hero: TargetDependency = .package(product: "Hero")
  static let RxDataSources: TargetDependency = .package(product: "RxDataSources")
}

public extension Package {
  static let Moya: Package = .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.0"))
  static let Nuke: Package = .remote(url: "https://github.com/kean/Nuke", requirement: .exact(.init(10, 6, 1)))
  static let Then: Package = .remote(url: "https://github.com/devxoul/Then", requirement: .exact(.init(2, 7, 0)))
  static let SnapKit: Package = .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.1"))
  static let firebase: Package = .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "8.0.0"))
  static let SkeletonView: Package = .remote(url: "https://github.com/Juanpe/SkeletonView.git", requirement: .upToNextMajor(from: "1.0.0"))
  static let CryptoSwift: Package = .remote(url: "https://github.com/krzyzanowskim/CryptoSwift.git", requirement: .upToNextMajor(from: "1.0.0"))
  static let Hero: Package = .remote(url: "https://github.com/HeroTransitions/Hero.git", requirement: .exact("1.5.0"))
  static let GoogleMapsUtils: Package = .remote(url: "https://github.com/googlemaps/google-maps-ios-utils.git", requirement: .upToNextMinor(from: "4.1.0"))
  static let RxSwift: Package = .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0"))
  static let RxGesture: Package = .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.0"))
  static let RIBs: Package = .remote(url: "https://github.com/uber/RIBs", requirement: .upToNextMajor(from: "0.12.1"))
  static let FlexLayout: Package = .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .exact("1.3.24"))
  static let PinLayout: Package = .remote(url: "https://github.com/layoutBox/PinLayout", requirement: .upToNextMajor(from: "1.0.0"))
  static let RxDataSources: Package = .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .upToNextMajor(from: "5.0.0"))
  }
