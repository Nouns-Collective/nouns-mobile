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
  @Environment(\.dismiss) private var dismiss
  @Environment(\.outlineTabBarVisibility) var outlineTabBarVisibility

  @StateObject var viewModel = ViewModel()
  
  @State private var isShareWithFriendsPresented = false
  @State private var isAppIconCollectionPresented = false
  private let localize = R.string.settings.self
  
  var body: some View {
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
        
        // A tutorial view is presented to guide the user on how to enable
        // the notification from the settings app if denied.
        Link(isActive: $viewModel.isNotificationPermissionTutorialPresented,
             content: { EmptyView() },
             destination: { NotificationPermission() })
      }
      .padding(.horizontal, 20)
      .softNavigationTitle(localize.title(), leftAccessory: {
        SoftButton(
          icon: { Image.back },
          action: { dismiss() })
      })
      .padding(.top, 20)
    }
    .background(Gradient.lemonDrop)
    .ignoresSafeArea(.all, edges: .bottom)
    .sheet(isPresented: $isShareWithFriendsPresented) {
      if let url = URL(string: "https://nouns.wtf") {
        ShareSheet(activityItems: [url])
      }
    }
    .notificationPermissionDialog(
      isPresented: $viewModel.isNotificationPermissionDialogPresented
    )
    .onAppear {
      outlineTabBarVisibility.hide()
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
