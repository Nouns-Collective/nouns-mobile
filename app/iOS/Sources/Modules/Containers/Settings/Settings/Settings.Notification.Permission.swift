//
//  Settings.PushNotification.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.03.22.
//

import SwiftUI
import UIComponents

/// `Motivation`:  Open the Settings app to enable notifications.
struct NotificationPermission: View {
  @Environment(\.openURL) private var openURL
  @Environment(\.dismiss) private var dismiss
  
  /// Holds a reference to the localized text.
  private let localize = R.string.settingsNotificationPermission.self
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .leading) {
        
        Text(localize.motivationTitle())
          .font(.custom(.bold, size: 17))
          .padding(.bottom, 1)
        
        Text(localize.motivationContent())
          .font(.custom(.regular, size: 17))
          .lineSpacing(4)
        
        Text(localize.instructionTitle())
          .font(.custom(.bold, size: 17))
          .padding(.top, 20)
        
        VStack(alignment: .leading, spacing: 17) {
          HStack {
            Text("1.")
              .font(.custom(.regular, size: 17))
            Image.notificationSettings
            Text(localize.instructionStep1())
              .font(.custom(.regular, size: 17))
          }
          
          HStack {
            Text("2.")
              .font(.custom(.regular, size: 17))
            Image.enabled
            Text(localize.instructionStep2())
              .font(.custom(.regular, size: 17))
          }
        }
        .padding(.leading, 15)
        .padding(.top, 5)
        
        OutlineButton(
          text: localize.enableNotificationAction(),
          smallAccessory: { Image.mdArrowRight },
          action: {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
              openURL(settingsURL)
            }
          })
          .controlSize(.large)
          .padding(.top, 25)
      }
      .padding(.horizontal, 20)
      .softNavigationTitle(localize.title(), leftAccessory: {
        // Pops view from the navigation stack.
        SoftButton(
          icon: { Image.back },
          action: { dismiss() })
      })
      .padding(.top, 20)
    }
    .background(Gradient.lemonDrop)
  }
}

struct NotificationPermission_Previews: PreviewProvider {
  static var previews: some View {
    NotificationPermission()
  }
}
