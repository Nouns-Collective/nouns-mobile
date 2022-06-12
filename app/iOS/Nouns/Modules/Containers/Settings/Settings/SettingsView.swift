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

/// States various settings of the app.
struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.outlineTabBarVisibility) var outlineTabBarVisibility

  @StateObject var viewModel = ViewModel()
  
  @State private var isShareWithFriendsPresented = false
  @State private var isAppIconCollectionPresented = false
  private let localize = R.string.settings.self
  
  @State private var showOnboarding: Bool = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack {
        NotificationSection(viewModel: viewModel)
        
        // App Icon
        LinkButton(
          isActive: $isAppIconCollectionPresented,
          leading: localize.appIconTitle(),
          icon: .nounGlassesIcon,
          destination: {
            AppIconStore()
          })
        
        // Share with friends
        DefaultButton(
          leading: localize.shareFriends(),
          icon: .share,
          action: { isShareWithFriendsPresented.toggle() })
        
        // App intro
        DefaultButton(
          leading: localize.appIntroTitle(),
          icon: .appIntro,
          action: { showOnboarding.toggle() })
        
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
      .padding(.top, 70)
    }
    .background(Gradient.lemonDrop)
    .overlay(.componentUnripeLemon, edge: .top)
    .ignoresSafeArea(edges: .top)
    .sheet(isPresented: $isShareWithFriendsPresented) {
      if let url = URL(string: "https://nouns.wtf") {
        ShareSheet(activityItems: [url])
      }
    }
    .notificationPermissionDialog(
      isPresented: $viewModel.isNotificationPermissionDialogPresented
    )
    .onAppear {
      viewModel.onAppear()
      outlineTabBarVisibility.hide()
    }
    .onboarding($showOnboarding)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
