//
//  CreateView.swift
//  Nouns
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Displays the Create Experience route.
struct CreateExperience: View {
  
  @State private var isPlaygroundPresented = false
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 20) {
          OffChainNounsFeed(isPlaygroundPresented: $isPlaygroundPresented)
        }
        .fullScreenCover(isPresented: $isPlaygroundPresented) {
          NounPlayground()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, tabBarHeight)
        .padding(.bottom, 20) // Extra padding between the bottom of the last noun card and the top of the tab view
        .softNavigationTitle(R.string.create.title(), rightAccessory: {
          SoftButton(
            text: "New",
            largeAccessory: { Image.new },
            action: { isPlaygroundPresented.toggle() })
        })
      }
      .background(Gradient.freshMint)
      .ignoresSafeArea(edges: .top)
    }
  }
}
