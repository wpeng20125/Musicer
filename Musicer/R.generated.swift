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

  /// This `R.color` struct is generated, and contains static references to 10 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `mu_color_black_with_alpha`.
    static let mu_color_black_with_alpha = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_black_with_alpha")
    /// Color `mu_color_black`.
    static let mu_color_black = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_black")
    /// Color `mu_color_clear`.
    static let mu_color_clear = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_clear")
    /// Color `mu_color_gray_dark`.
    static let mu_color_gray_dark = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_gray_dark")
    /// Color `mu_color_gray_light`.
    static let mu_color_gray_light = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_gray_light")
    /// Color `mu_color_orange_dark`.
    static let mu_color_orange_dark = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_orange_dark")
    /// Color `mu_color_orange_light`.
    static let mu_color_orange_light = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_orange_light")
    /// Color `mu_color_progress_bg`.
    static let mu_color_progress_bg = Rswift.ColorResource(bundle: R.hostingBundle, name: "mu_color_progress_bg")
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
    /// `UIColor(named: "mu_color_black", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_black(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_black, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_black_with_alpha", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_black_with_alpha(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_black_with_alpha, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_clear", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_clear(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_clear, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_gray_dark", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_gray_dark(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_gray_dark, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_gray_light", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_gray_light(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_gray_light, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_orange_dark", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_orange_dark(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_orange_dark, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_orange_light", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_orange_light(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_orange_light, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "mu_color_progress_bg", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mu_color_progress_bg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mu_color_progress_bg, compatibleWith: traitCollection)
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

  /// This `R.image` struct is generated, and contains static references to 50 images.
  struct image {
    /// Image `LaunchScreen`.
    static let launchScreen = Rswift.ImageResource(bundle: R.hostingBundle, name: "LaunchScreen")
    /// Image `mu_image_control_pull`.
    static let mu_image_control_pull = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_control_pull")
    /// Image `mu_image_play_last`.
    static let mu_image_play_last = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_last")
    /// Image `mu_image_play_list_loop`.
    static let mu_image_play_list_loop = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_list_loop")
    /// Image `mu_image_play_mode_headset`.
    static let mu_image_play_mode_headset = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_mode_headset")
    /// Image `mu_image_play_mode_speaker`.
    static let mu_image_play_mode_speaker = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_mode_speaker")
    /// Image `mu_image_play_next`.
    static let mu_image_play_next = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_next")
    /// Image `mu_image_play_random`.
    static let mu_image_play_random = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_random")
    /// Image `mu_image_play_single_loop`.
    static let mu_image_play_single_loop = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_single_loop")
    /// Image `mu_image_play_squence`.
    static let mu_image_play_squence = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play_squence")
    /// Image `mu_image_play`.
    static let mu_image_play = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_play")
    /// Image `mu_image_song_share`.
    static let mu_image_song_share = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_song_share")
    /// Image `mu_image_songs_add`.
    static let mu_image_songs_add = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_songs_add")
    /// Image `mu_image_songs_folder_all`.
    static let mu_image_songs_folder_all = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_songs_folder_all")
    /// Image `mu_image_songs_folder_current`.
    static let mu_image_songs_folder_current = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_songs_folder_current")
    /// Image `mu_image_songs_folder_favourite`.
    static let mu_image_songs_folder_favourite = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_songs_folder_favourite")
    /// Image `mu_image_toast_loading_1`.
    static let mu_image_toast_loading_1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_toast_loading_1")
    /// Image `mu_image_toast_loading_2`.
    static let mu_image_toast_loading_2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_toast_loading_2")
    /// Image `mu_image_upload_close`.
    static let mu_image_upload_close = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_upload_close")
    /// Image `mu_image_upload_wifi`.
    static let mu_image_upload_wifi = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_image_upload_wifi")
    /// Image `mu_imge_music_note_10`.
    static let mu_imge_music_note_10 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_10")
    /// Image `mu_imge_music_note_11`.
    static let mu_imge_music_note_11 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_11")
    /// Image `mu_imge_music_note_12`.
    static let mu_imge_music_note_12 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_12")
    /// Image `mu_imge_music_note_13`.
    static let mu_imge_music_note_13 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_13")
    /// Image `mu_imge_music_note_14`.
    static let mu_imge_music_note_14 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_14")
    /// Image `mu_imge_music_note_15`.
    static let mu_imge_music_note_15 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_15")
    /// Image `mu_imge_music_note_16`.
    static let mu_imge_music_note_16 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_16")
    /// Image `mu_imge_music_note_17`.
    static let mu_imge_music_note_17 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_17")
    /// Image `mu_imge_music_note_18`.
    static let mu_imge_music_note_18 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_18")
    /// Image `mu_imge_music_note_19`.
    static let mu_imge_music_note_19 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_19")
    /// Image `mu_imge_music_note_1`.
    static let mu_imge_music_note_1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_1")
    /// Image `mu_imge_music_note_20`.
    static let mu_imge_music_note_20 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_20")
    /// Image `mu_imge_music_note_21`.
    static let mu_imge_music_note_21 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_21")
    /// Image `mu_imge_music_note_22`.
    static let mu_imge_music_note_22 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_22")
    /// Image `mu_imge_music_note_23`.
    static let mu_imge_music_note_23 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_23")
    /// Image `mu_imge_music_note_24`.
    static let mu_imge_music_note_24 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_24")
    /// Image `mu_imge_music_note_25`.
    static let mu_imge_music_note_25 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_25")
    /// Image `mu_imge_music_note_26`.
    static let mu_imge_music_note_26 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_26")
    /// Image `mu_imge_music_note_27`.
    static let mu_imge_music_note_27 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_27")
    /// Image `mu_imge_music_note_28`.
    static let mu_imge_music_note_28 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_28")
    /// Image `mu_imge_music_note_29`.
    static let mu_imge_music_note_29 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_29")
    /// Image `mu_imge_music_note_2`.
    static let mu_imge_music_note_2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_2")
    /// Image `mu_imge_music_note_30`.
    static let mu_imge_music_note_30 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_30")
    /// Image `mu_imge_music_note_3`.
    static let mu_imge_music_note_3 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_3")
    /// Image `mu_imge_music_note_4`.
    static let mu_imge_music_note_4 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_4")
    /// Image `mu_imge_music_note_5`.
    static let mu_imge_music_note_5 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_5")
    /// Image `mu_imge_music_note_6`.
    static let mu_imge_music_note_6 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_6")
    /// Image `mu_imge_music_note_7`.
    static let mu_imge_music_note_7 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_7")
    /// Image `mu_imge_music_note_8`.
    static let mu_imge_music_note_8 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_8")
    /// Image `mu_imge_music_note_9`.
    static let mu_imge_music_note_9 = Rswift.ImageResource(bundle: R.hostingBundle, name: "mu_imge_music_note_9")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "LaunchScreen", bundle: ..., traitCollection: ...)`
    static func launchScreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launchScreen, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_control_pull", bundle: ..., traitCollection: ...)`
    static func mu_image_control_pull(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_control_pull, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play", bundle: ..., traitCollection: ...)`
    static func mu_image_play(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_last", bundle: ..., traitCollection: ...)`
    static func mu_image_play_last(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_last, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_list_loop", bundle: ..., traitCollection: ...)`
    static func mu_image_play_list_loop(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_list_loop, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_mode_headset", bundle: ..., traitCollection: ...)`
    static func mu_image_play_mode_headset(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_mode_headset, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_mode_speaker", bundle: ..., traitCollection: ...)`
    static func mu_image_play_mode_speaker(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_mode_speaker, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_next", bundle: ..., traitCollection: ...)`
    static func mu_image_play_next(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_next, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_random", bundle: ..., traitCollection: ...)`
    static func mu_image_play_random(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_random, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_single_loop", bundle: ..., traitCollection: ...)`
    static func mu_image_play_single_loop(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_single_loop, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_play_squence", bundle: ..., traitCollection: ...)`
    static func mu_image_play_squence(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_play_squence, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_song_share", bundle: ..., traitCollection: ...)`
    static func mu_image_song_share(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_song_share, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_songs_add", bundle: ..., traitCollection: ...)`
    static func mu_image_songs_add(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_songs_add, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_songs_folder_all", bundle: ..., traitCollection: ...)`
    static func mu_image_songs_folder_all(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_songs_folder_all, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_songs_folder_current", bundle: ..., traitCollection: ...)`
    static func mu_image_songs_folder_current(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_songs_folder_current, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_songs_folder_favourite", bundle: ..., traitCollection: ...)`
    static func mu_image_songs_folder_favourite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_songs_folder_favourite, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_toast_loading_1", bundle: ..., traitCollection: ...)`
    static func mu_image_toast_loading_1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_toast_loading_1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_toast_loading_2", bundle: ..., traitCollection: ...)`
    static func mu_image_toast_loading_2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_toast_loading_2, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_upload_close", bundle: ..., traitCollection: ...)`
    static func mu_image_upload_close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_upload_close, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_image_upload_wifi", bundle: ..., traitCollection: ...)`
    static func mu_image_upload_wifi(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_image_upload_wifi, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_1", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_10", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_10(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_10, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_11", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_11(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_11, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_12", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_12(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_12, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_13", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_13(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_13, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_14", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_14(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_14, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_15", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_15(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_15, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_16", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_16(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_16, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_17", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_17(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_17, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_18", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_18(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_18, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_19", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_19(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_19, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_2", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_2, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_20", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_20(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_20, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_21", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_21(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_21, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_22", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_22(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_22, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_23", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_23(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_23, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_24", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_24(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_24, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_25", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_25(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_25, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_26", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_26(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_26, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_27", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_27(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_27, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_28", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_28(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_28, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_29", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_29(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_29, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_3", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_3, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_30", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_30(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_30, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_4", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_4(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_4, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_5", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_5(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_5, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_6", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_6(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_6, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_7", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_7(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_7, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_8", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_8(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_8, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mu_imge_music_note_9", bundle: ..., traitCollection: ...)`
    static func mu_imge_music_note_9(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mu_imge_music_note_9, compatibleWith: traitCollection)
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
