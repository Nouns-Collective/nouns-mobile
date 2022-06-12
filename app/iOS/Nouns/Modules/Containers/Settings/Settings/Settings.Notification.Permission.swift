// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI
import NounsUI

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
