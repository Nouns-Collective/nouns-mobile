//
//  SettingsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

struct SettingsView: View {
  @State private var isNotificationOn = true
  
  init() {
    // TODO: Theming Should be extracted as it is related to the theme.
    UINavigationBar.appearance().barTintColor = .clear
    UITableView.appearance().backgroundColor = .clear
  }
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack {
          
          OutlineButton(
            text: R.string.settings.notificationTitle(),
            icon: { Image.speaker },
            accessory: {
              OutlineToggle(isOn: $isNotificationOn)
            },
            action: { },
            fill: [.width])
          
          Text(R.string.settings.notificationNote())
            .font(.custom(.regular, size: 13))
            .foregroundColor(Color.componentNounsBlack.opacity(0.6))
            .padding(.bottom, 10)
          
          OutlineButton(
            text: R.string.settings.themeTitle(),
            icon: { Image.theme },
            accessory: {
              Text(R.string.settings.themeSystem())
                .font(.custom(.regular, size: 17))
                .foregroundColor(Color.componentNounsBlack.opacity(0.5))
            },
            smallAccessory: { Image.squareArrowDown },
            action: { },
            fill: [.width])
          
          OutlineButton(
            text: R.string.settings.appIconTitle(),
            icon: { Image.nounLogo.renderingMode(.template) },
            accessory: {
              Text(R.string.settings.appIconDefault())
                .font(.custom(.regular, size: 17))
                .foregroundColor(Color.componentNounsBlack.opacity(0.5))
            },
            smallAccessory: { Image.squareArrowDown },
            action: { },
            fill: [.width])
          
          OutlineButton(
            text: R.string.settings.shareFriends(),
            icon: { Image.share },
            smallAccessory: { Image.squareArrowDown },
            action: { },
            fill: [.width])
        }
        .padding(.horizontal, 20)
        .softNavigationTitle(R.string.settings.title())
      }
      .background(Gradient.bubbleGum)
      .ignoresSafeArea()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
