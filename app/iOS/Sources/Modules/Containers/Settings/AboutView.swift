//
//  AboutView.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct AboutView: View {
  @Environment(\.outlineTabViewHeight) var tabBarHeight
  
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
        }
        .padding(.horizontal, 20)
        .padding(.bottom, tabBarHeight)
        // Extra padding between the bottom of the last noun card and the top of the tab view
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
      }
      .ignoresSafeArea(edges: .top)
      .background(Gradient.lemonDrop)
      .bottomSheet(isPresented: $isAboutNounsPresented, content: {
        AboutNounsView(isPresented: $isAboutNounsPresented)
      })
    }
  }
}
