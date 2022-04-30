//
//  Symbol.swift
//  
//
//  Created by Ziad Tamim on 10.11.21.
//

import SwiftUI

/// Creates a labeled image that you can use as content for controls.
extension Image {
  
  public static let appIntro = Image("app-intro", bundle: .module)
  
  public static let crown = Image("crown", bundle: .module)
  
  public static let active = Image("sm-active", bundle: .module)
  
  public static let cancel = Image("sm-cancel", bundle: .module)
  
  public static let check = Image("sm-check", bundle: .module)
  
  public static let queued = Image("sm-queued", bundle: .module)
  
  public static let pending = Image("sm-pending", bundle: .module)
  
  public static let absent = Image("sm-absent", bundle: .module)
  
  public static let smArrowOut = Image("sm-arrow-out", bundle: .module)
  
  public static let save = Image("save", bundle: .module)
  
  public static let about = Image("about", bundle: .module)
  
  public static let speaker = Image("speaker", bundle: .module)
  
  public static let fingergunsRight = Image("fingerguns-right", bundle: .module)
  
  public static let theme = Image("theme", bundle: .module)
  
  public static let back = Image("back", bundle: .module)
  
  public static let help = Image("help", bundle: .module)
  
  public static let birthday = Image("birthday", bundle: .module)
  
  public static let checkmark = Image("checkmark", bundle: .module)
  
  public static let chevronDown = Image("chevron-down", bundle: .module)
  
  public static let chevronCompactUp = Image("chevron.compact.up", bundle: .module)
  
  public static let createFill = Image("create-fill", bundle: .module)
  
  public static let createOutline = Image("create-outline", bundle: .module)
  
  public static let currentBid = Image("current-bid", bundle: .module)
  
  public static let eth = Image("eth", bundle: .module)
  
  public static let exploreFill = Image("explore-fill", bundle: .module)
  
  public static let exploreOutline = Image("explore-outline", bundle: .module)
  
  public static let gear = Image("gear", bundle: .module)
  
  public static let history = Image("history", bundle: .module)
  
  public static let holder = Image("holder", bundle: .module)
  
  public static let noSign = Image("no-sign", bundle: .module)
  
  public static let mdArrowCorner = Image("md-arrow-corner", bundle: .module)
  
  public static let mdArrowRight = Image("md-arrow-right", bundle: .module)
  
  public static let new = Image("new", bundle: .module)
  
  public static let nightmode = Image("nightmode", bundle: .module)
  
  public static let notification = Image("notification", bundle: .module)
  
  public static let nounGlassesIcon = Image("noun-glasses-icon", bundle: .module)

  public static let nounLogo = Image("noun-logo", bundle: .module)
  
  public static let options = Image("options", bundle: .module)
  
  public static let playFill = Image("play-fill", bundle: .module)
  
  public static let playOutline = Image("play-outline", bundle: .module)
  
  public static let xmark = Image("xmark", bundle: .module)
  
  public static let rename = Image("rename", bundle: .module)
  
  public static let retry = Image("retry", bundle: .module)
  
  public static let settingsFill = Image("settings-fill", bundle: .module)
  
  public static let settingsOutline = Image("settings-outline", bundle: .module)
  
  public static let share = Image("share", bundle: .module)
  
  public static let smAbsent = Image("sm-absent", bundle: .module)
  
  public static let timeleft = Image("timeleft", bundle: .module)
  
  public static let trash = Image("trash", bundle: .module)
  
  public static let vector = Image("vector", bundle: .module)
  
  public static let web = Image("web", bundle: .module)
  
  public static let wonPrice = Image("won-price", bundle: .module)
  
  public static let squareArrowDown = Image("square.and.arrow.down", bundle: .module)
  
  public static let splice = Image("splice", bundle: .module)
  
  public static let shakePhone = Image("shake-phone", bundle: .module)
  
  public static let swipePick = Image("swipe-pick", bundle: .module)
  
  public enum PointRight {
    
    public static let standard = Image("hand-point-right", bundle: .module)
    
    public static let white = Image("hand-point-right-white", bundle: .module)
  }
  
  public static let alien = Image("alien", bundle: .module)
  
  public static let chipmunk = Image("chipmunk", bundle: .module)
  
  public static let monster = Image("monster", bundle: .module)
  
  public static let robot = Image("robot", bundle: .module)
  
  public static let later = Image("later", bundle: .module)
  
  public enum Controls {
    
    public static let play = Image("play", bundle: .module)
    
    public static let pause = Image("pause", bundle: .module)
  }
  
  public static let aboutFill = Image("about-fill", bundle: .module)
  
  public static let aboutOutline = Image("about-outline", bundle: .module)
  
  public static let enabled = Image("enabled", bundle: .module)
  
  public static let notificationSettings = Image("notification-settings", bundle: .module)
}

extension UIImage {
  
  public static let checkmark = UIImage(named: "checkmark", in: .module, with: nil)
}

struct Symbol_Preview: PreviewProvider {
  static var previews: some View {
    VStack {
      HStack {
        Image.enabled
        Image.notificationSettings
      }
    }
  }
}
