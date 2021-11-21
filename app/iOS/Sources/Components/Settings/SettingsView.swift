//
//  SettingsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

struct SettingsView: View {
  
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
            text: "Noun O’Clock Notification",
            icon: { Image.speaker },
            smallAccessory: { Image.squareArrowDown },
            action: { },
            fill: [.width])
          
          Text("Every day a new noun is released to auction, and as the timer runs down, bidding can get wild. Get notified when this glorious hour approaches.")
            .font(.custom(.regular, size: 13))
            .foregroundColor(Color.componentNounsBlack.opacity(0.6))
            .padding(.bottom, 10)
          
          OutlineButton(
            text: "Theme",
            icon: { Image.theme },
            smallAccessory: { Image.squareArrowDown },
            action: { },
            fill: [.width])
          
          OutlineButton(
            text: "App Icon",
            icon: { Image.nounLogo.renderingMode(.template) },
            smallAccessory: {
              Image.squareArrowDown
            },
            action: { },
            fill: [.width])
          
          OutlineButton(
            text: "Share with friends",
            icon: { Image.share },
            smallAccessory: { Image.squareArrowDown },
            action: { },
            fill: [.width])
        }
        .padding(.horizontal, 20)
        .softNavigationTitle("Settings")
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
