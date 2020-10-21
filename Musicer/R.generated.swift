//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 7 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `mu_color_alpha_zero`.
    static let mu_color_alpha_zero = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_alpha_zero")
    /// Color `mu_color_black`.
    static let mu_color_black = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_black")
    /// Color `mu_color_gray`.
    static let mu_color_gray = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_gray")
    /// Color `mu_color_orange_one`.
    static let mu_color_orange_one = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_orange_one")
    /// Color `mu_color_orange_two`.
    static let mu_color_orange_two = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_orange_two")
    /// Color `mu_color_white`.
    static let mu_color_white = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_white")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_alpha_zero", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_alpha_zero(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_alpha_zero, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_black", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_black, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_gray", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_gray(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_gray, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_orange_one", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_orange_one(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_orange_one, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_orange_two", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_orange_two(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_orange_two, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_white", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_white, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 16 images.
  struct image {
    /// Image `LaunchScreen`.
    static let launchScreen = Rswift.ImageResource(bundle: R.hostingBundle, name: "LaunchScreen")
    /// Image `mu_image_add_songs`.
    static let mu_image_add_songs = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_add_songs")
    /// Image `mu_image_close`.
    static let mu_image_close = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_close")
    /// Image `mu_image_collect`.
    static let mu_image_collect = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_collect")
    /// Image `mu_image_last_song`.
    static let mu_image_last_song = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_last_song")
    /// Image `mu_image_list_loop_play`.
    static let mu_image_list_loop_play = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_list_loop_play")
    /// Image `mu_image_list_play`.
    static let mu_image_list_play = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_list_play")
    /// Image `mu_image_mode_ speaker`.
    static let mu_image_mode_Speaker = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_mode_ speaker")
    /// Image `mu_image_mode_headset`.
    static let mu_image_mode_headset = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_mode_headset")
    /// Image `mu_image_next_song`.
    static let mu_image_next_song = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_next_song")
    /// Image `mu_image_play`.
    static let mu_image_play = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play")
    /// Image `mu_image_random_play`.
    static let mu_image_random_play = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_random_play")
    /// Image `mu_image_single_loop_play`.
    static let mu_image_single_loop_play = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_single_loop_play")
    /// Image `mu_image_songs_folder_current`.
    static let mu_image_songs_folder_current = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_songs_folder_current")
    /// Image `mu_image_songs_folders`.
    static let mu_image_songs_folders = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_songs_folders")
    /// Image `mu_image_wifi`.
    static let mu_image_wifi = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_wifi")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "LaunchScreen", bundle: ..., traitCollection: ...)`
    static func launchScreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launchScreen, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_add_songs", bundle: ..., traitCollection: ...)`
    static func mu_image_add_songs(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_add_songs, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_close", bundle: ..., traitCollection: ...)`
    static func mu_image_close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_close, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_collect", bundle: ..., traitCollection: ...)`
    static func mu_image_collect(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_collect, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_last_song", bundle: ..., traitCollection: ...)`
    static func mu_image_last_song(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_last_song, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_list_loop_play", bundle: ..., traitCollection: ...)`
    static func mu_image_list_loop_play(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_list_loop_play, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_list_play", bundle: ..., traitCollection: ...)`
    static func mu_image_list_play(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_list_play, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_mode_ speaker", bundle: ..., traitCollection: ...)`
    static func mu_image_mode_Speaker(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_mode_Speaker, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_mode_headset", bundle: ..., traitCollection: ...)`
    static func mu_image_mode_headset(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_mode_headset, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_next_song", bundle: ..., traitCollection: ...)`
    static func mu_image_next_song(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_next_song, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play", bundle: ..., traitCollection: ...)`
    static func mu_image_play(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_random_play", bundle: ..., traitCollection: ...)`
    static func mu_image_random_play(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_random_play, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_single_loop_play", bundle: ..., traitCollection: ...)`
    static func mu_image_single_loop_play(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_single_loop_play, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_songs_folder_current", bundle: ..., traitCollection: ...)`
    static func mu_image_songs_folder_current(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_songs_folder_current, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_songs_folders", bundle: ..., traitCollection: ...)`
    static func mu_image_songs_folders(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_songs_folders, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_wifi", bundle: ..., traitCollection: ...)`
    static func mu_image_wifi(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_wifi, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "LaunchScreen", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'LaunchScreen' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
