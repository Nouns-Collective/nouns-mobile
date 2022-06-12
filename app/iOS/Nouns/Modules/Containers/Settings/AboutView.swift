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

struct AboutView: View {
  @StateObject var viewModel = ViewModel()

  @Environment(\.outlineTabViewHeight) var tabBarHeight
  @Environment(\.outlineTabBarVisibility) var outlineTabBarVisibility

  @State private var isAboutNounsPresented = false
  @State private var isSettingsPresented = false
  
  /// Holds a reference to the localized text.
  private let localize = R.string.about.self
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          GovernanceInfoSection(isAboutNounsPresented: $isAboutNounsPresented)
          ProposalsInfoSection()
          SpacesInfoSection()
          DocumentationInfoSection()
          DerivativeProjectsInfoSection()
          TeamInfoSection()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, tabBarHeight)
        // Extra padding between the bottom of the last noun
        // card and the top of the tab view
        .padding(.bottom, 40)
        .softNavigationTitle(localize.title(), rightAccessory: {
          Link(isActive: $isSettingsPresented, content: {
            // App's Settings
            Button(action: {
              isSettingsPresented.toggle()
            }, label: {
              Image.settingsOutline
            })
            
          }, destination: {
            SettingsView()
          })
        })
        .id(AppPage.about.scrollToTopId)
      }
      .overlay(.componentUnripeLemon, edge: .top)
      .ignoresSafeArea(edges: .top)
      .background(Gradient.lemonDrop)
      .bottomSheet(isPresented: $isAboutNounsPresented, content: {
        AboutNounsView(isPresented: $isAboutNounsPresented)
      })
      .onAppear {
        viewModel.onAppear()
        outlineTabBarVisibility.show()
      }
    }
  }
}
