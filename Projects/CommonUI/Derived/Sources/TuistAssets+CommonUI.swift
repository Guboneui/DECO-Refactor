// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum CommonUIAsset {
  public enum Color {
    public static let blackColor = CommonUIColors(name: "BlackColor")
    public static let darkGray1 = CommonUIColors(name: "DarkGray1")
    public static let darkGray2 = CommonUIColors(name: "DarkGray2")
    public static let gray1 = CommonUIColors(name: "Gray1")
    public static let gray2 = CommonUIColors(name: "Gray2")
    public static let gray3 = CommonUIColors(name: "Gray3")
    public static let gray4 = CommonUIColors(name: "Gray4")
    public static let kakao = CommonUIColors(name: "Kakao")
    public static let lightBackground3 = CommonUIColors(name: "LightBackground3")
    public static let lightGray1 = CommonUIColors(name: "LightGray1")
    public static let lightGray2 = CommonUIColors(name: "LightGray2")
    public static let lightPrimaryColor = CommonUIColors(name: "LightPrimaryColor")
    public static let lightSecondaryColor = CommonUIColors(name: "LightSecondaryColor")
    public static let naver = CommonUIColors(name: "Naver")
    public static let primaryColor = CommonUIColors(name: "PrimaryColor")
    public static let secondaryColor = CommonUIColors(name: "SecondaryColor")
    public static let successColor = CommonUIColors(name: "SuccessColor")
    public static let warningColor = CommonUIColors(name: "WarningColor")
    public static let whiteColor = CommonUIColors(name: "WhiteColor")
  }
  public enum Image {
    public static let again = CommonUIImages(name: "again")
    public static let appleLogo = CommonUIImages(name: "appleLogo")
    public static let arrow = CommonUIImages(name: "arrow")
    public static let arrowDarkgrey2 = CommonUIImages(name: "arrow_darkgrey_2")
    public static let arrowRight = CommonUIImages(name: "arrow_right")
    public static let arrowWhite = CommonUIImages(name: "arrow_white")
    public static let back = CommonUIImages(name: "back")
    public static let bell = CommonUIImages(name: "bell")
    public static let bellOn = CommonUIImages(name: "bell_on")
    public static let bulb = CommonUIImages(name: "bulb")
    public static let bulbWhite = CommonUIImages(name: "bulb_white")
    public static let bye = CommonUIImages(name: "bye")
    public static let camera = CommonUIImages(name: "camera")
    public static let cameraWhite = CommonUIImages(name: "camera_white")
    public static let checkColor = CommonUIImages(name: "check_color")
    public static let checkLightgrey1 = CommonUIImages(name: "check_lightgrey_1")
    public static let checkSec = CommonUIImages(name: "check_sec")
    public static let close = CommonUIImages(name: "close")
    public static let closeSec = CommonUIImages(name: "close_sec")
    public static let closeWhite = CommonUIImages(name: "close_white")
    public static let coloring = CommonUIImages(name: "coloring")
    public static let coloringWhite = CommonUIImages(name: "coloring_white")
    public static let cute = CommonUIImages(name: "cute")
    public static let defaultBookmark = CommonUIImages(name: "defaultBookmark")
    public static let defaultHome = CommonUIImages(name: "defaultHome")
    public static let defaultProduct = CommonUIImages(name: "defaultProduct")
    public static let defaultProfile = CommonUIImages(name: "defaultProfile")
    public static let defaultUpload = CommonUIImages(name: "defaultUpload")
    public static let filter = CommonUIImages(name: "filter")
    public static let filterWhite = CommonUIImages(name: "filter_white")
    public static let findlistNavi = CommonUIImages(name: "findlist-navi")
    public static let findlist = CommonUIImages(name: "findlist")
    public static let findlistWhite = CommonUIImages(name: "findlist_white")
    public static let googleLogo = CommonUIImages(name: "googleLogo")
    public static let homeNavi = CommonUIImages(name: "home-navi")
    public static let home = CommonUIImages(name: "home")
    public static let homeWhite = CommonUIImages(name: "home_white")
    public static let info = CommonUIImages(name: "info")
    public static let infoWhite = CommonUIImages(name: "info_white")
    public static let kakaoLogo = CommonUIImages(name: "kakaoLogo")
    public static let kitch = CommonUIImages(name: "kitch")
    public static let like = CommonUIImages(name: "like")
    public static let likeFull = CommonUIImages(name: "like_full")
    public static let likeFullWhite = CommonUIImages(name: "like_full_white")
    public static let likeWhite = CommonUIImages(name: "like_white")
    public static let listsWhite = CommonUIImages(name: "lists_white")
    public static let listupDarkgrey2 = CommonUIImages(name: "listup_darkgrey_2")
    public static let loadingWhite = CommonUIImages(name: "loading_white")
    public static let login = CommonUIImages(name: "login")
    public static let logoDarkgray = CommonUIImages(name: "logoDarkgray")
    public static let logoWhite = CommonUIImages(name: "logoWhite")
    public static let logoYellow = CommonUIImages(name: "logoYellow")
    public static let message = CommonUIImages(name: "message")
    public static let messageFullWhite = CommonUIImages(name: "message_full_white")
    public static let messageWhite = CommonUIImages(name: "message_white")
    public static let moreWhite = CommonUIImages(name: "more_white")
    public static let naverLogo = CommonUIImages(name: "naverLogo")
    public static let paper = CommonUIImages(name: "paper")
    public static let paperWhite = CommonUIImages(name: "paper_white")
    public static let pen = CommonUIImages(name: "pen")
    public static let penWhite = CommonUIImages(name: "pen_white")
    public static let profileNavi = CommonUIImages(name: "profile-navi")
    public static let profile = CommonUIImages(name: "profile")
    public static let profileWhite = CommonUIImages(name: "profile_white")
    public static let question = CommonUIImages(name: "question")
    public static let resetDarkgrey2 = CommonUIImages(name: "reset_darkgrey_2")
    public static let save = CommonUIImages(name: "save")
    public static let saveFull = CommonUIImages(name: "save_full")
    public static let saveFullWhite = CommonUIImages(name: "save_full_white")
    public static let saveThick = CommonUIImages(name: "save_thick")
    public static let saveThickWhite = CommonUIImages(name: "save_thick_white")
    public static let search = CommonUIImages(name: "search")
    public static let searchGrey2 = CommonUIImages(name: "search_grey_2")
    public static let sense = CommonUIImages(name: "sense")
    public static let setting = CommonUIImages(name: "setting")
    public static let settingWhite = CommonUIImages(name: "setting_white")
    public static let showGrey1 = CommonUIImages(name: "show_grey_1")
    public static let simple = CommonUIImages(name: "simple")
    public static let talk = CommonUIImages(name: "talk")
    public static let talkWhite = CommonUIImages(name: "talk_white")
    public static let text = CommonUIImages(name: "text")
    public static let textWhite = CommonUIImages(name: "text_white")
    public static let textalignLeftWhite = CommonUIImages(name: "textalign_left_white")
    public static let textalignMidWhite = CommonUIImages(name: "textalign_mid_white")
    public static let textalignRightWhite = CommonUIImages(name: "textalign_right_white")
    public static let textcolor = CommonUIImages(name: "textcolor")
    public static let textcolorWhite = CommonUIImages(name: "textcolor_white")
    public static let thumbnail = CommonUIImages(name: "thumbnail")
    public static let upload = CommonUIImages(name: "upload")
    public static let uploadDarkgrey2 = CommonUIImages(name: "upload_darkgrey_2")
    public static let uploadFull = CommonUIImages(name: "upload_full")
    public static let uploadSec = CommonUIImages(name: "upload_sec")
    public static let uploadWhite = CommonUIImages(name: "upload_white")
    public static let vintage = CommonUIImages(name: "vintage")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class CommonUIColors {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if canImport(SwiftUI)
  private var _swiftUIColor: Any? = nil
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) var swiftUIColor: SwiftUI.Color {
    get {
      if self._swiftUIColor == nil {
        self._swiftUIColor = SwiftUI.Color(asset: self)
      }

      return self._swiftUIColor as! SwiftUI.Color
    }
    set {
      self._swiftUIColor = newValue
    }
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension CommonUIColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: CommonUIColors) {
    let bundle = CommonUIResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: CommonUIColors) {
    let bundle = CommonUIResources.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct CommonUIImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = CommonUIResources.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension CommonUIImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the CommonUIImages.image property")
  convenience init?(asset: CommonUIImages) {
    #if os(iOS) || os(tvOS)
    let bundle = CommonUIResources.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: CommonUIImages) {
    let bundle = CommonUIResources.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: CommonUIImages, label: Text) {
    let bundle = CommonUIResources.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: CommonUIImages) {
    let bundle = CommonUIResources.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
