// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum CommonUIFontFamily {
  public enum NotoSansKR {
    public static let black = CommonUIFontConvertible(name: "NotoSansKR-Black", family: "Noto Sans KR", path: "NotoSansKR-Black.otf")
    public static let bold = CommonUIFontConvertible(name: "NotoSansKR-Bold", family: "Noto Sans KR", path: "NotoSansKR-Bold.otf")
    public static let light = CommonUIFontConvertible(name: "NotoSansKR-Light", family: "Noto Sans KR", path: "NotoSansKR-Light.otf")
    public static let medium = CommonUIFontConvertible(name: "NotoSansKR-Medium", family: "Noto Sans KR", path: "NotoSansKR-Medium.otf")
    public static let regular = CommonUIFontConvertible(name: "NotoSansKR-Regular", family: "Noto Sans KR", path: "NotoSansKR-Regular.otf")
    public static let thin = CommonUIFontConvertible(name: "NotoSansKR-Thin", family: "Noto Sans KR", path: "NotoSansKR-Thin.otf")
    public static let all: [CommonUIFontConvertible] = [black, bold, light, medium, regular, thin]
  }
  public enum Suit {
    public static let bold = CommonUIFontConvertible(name: "SUIT-Bold", family: "SUIT", path: "SUIT-Bold.otf")
    public static let extraBold = CommonUIFontConvertible(name: "SUIT-ExtraBold", family: "SUIT", path: "SUIT-ExtraBold.otf")
    public static let extraLight = CommonUIFontConvertible(name: "SUIT-ExtraLight", family: "SUIT", path: "SUIT-ExtraLight.otf")
    public static let heavy = CommonUIFontConvertible(name: "SUIT-Heavy", family: "SUIT", path: "SUIT-Heavy.otf")
    public static let light = CommonUIFontConvertible(name: "SUIT-Light", family: "SUIT", path: "SUIT-Light.otf")
    public static let medium = CommonUIFontConvertible(name: "SUIT-Medium", family: "SUIT", path: "SUIT-Medium.otf")
    public static let regular = CommonUIFontConvertible(name: "SUIT-Regular", family: "SUIT", path: "SUIT-Regular.otf")
    public static let semiBold = CommonUIFontConvertible(name: "SUIT-SemiBold", family: "SUIT", path: "SUIT-SemiBold.otf")
    public static let thin = CommonUIFontConvertible(name: "SUIT-Thin", family: "SUIT", path: "SUIT-Thin.otf")
    public static let all: [CommonUIFontConvertible] = [bold, extraBold, extraLight, heavy, light, medium, regular, semiBold, thin]
  }
  public static let allCustomFonts: [CommonUIFontConvertible] = [NotoSansKR.all, Suit.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct CommonUIFontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return Bundle.module.url(forResource: path, withExtension: nil)
  }
}

public extension CommonUIFontConvertible.Font {
  convenience init?(font: CommonUIFontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}
// swiftlint:enable all
// swiftformat:enable all
