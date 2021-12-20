//
//  SettingsView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents

/// States various settings of the app.
struct SettingsView: View {
  @StateObject var viewModel = ViewModel()
  
  @Environment(\.dismiss) private var dismiss
  @State private var isShareWithFriendsPresented = false
  @State private var isAppIconCollectionPresented = false
  private let localize = R.string.settings.self
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack {
          NotificationSection(viewModel: viewModel)
          
          // App Icon
          LinkButton(
            isActive: $isAppIconCollectionPresented,
            leading: localize.appIconTitle(),
            trailing: localize.appIconDefault(),
            icon: .nounLogo,
            destination: {
              AppIconStore()
            })
          
          // Share with friends
          DefaultButton(
            leading: localize.shareFriends(),
            icon: .share,
            action: { isShareWithFriendsPresented.toggle() })
        }
        .padding(.horizontal, 20)
        .softNavigationTitle(localize.title(), rightAccessory: {
          // Dismisses the current views
          SoftButton(
            icon: { Image.xmark },
            action: { dismiss() })
        })
      }
      .background(Gradient.bubbleGum)
      .ignoresSafeArea()
      .sheet(isPresented: $isShareWithFriendsPresented) {
        if let url = URL(string: "https://nouns.wtf") {
          ShareSheet(activityItems: [url])
        }
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
