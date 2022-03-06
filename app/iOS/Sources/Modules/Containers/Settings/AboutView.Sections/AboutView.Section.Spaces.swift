//
//  SpacesInfoSection.swift
//  Nouns
//
//  Created by Ziad Tamim on 05.12.21.
//

import SwiftUI
import UIComponents

struct SpacesInfoSection: View {
  private let localize = R.string.spaces.self
  @State private var isSafariPresented = false
  @State private var selectedURL: URL?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())
      
      // Discord
      SpaceRow(localize.discordTitle(), action: {
        selectedURL = URL(string: localize.discordLink())
      })
      
      // Twitter
      SpaceRow(localize.twitterTitle(), action: {
        selectedURL = URL(string: localize.twitterLink())
      })
      
      // Etherscan
      SpaceRow(localize.etherscanTitle(), action: {
        selectedURL = URL(string: localize.etherscanLink())
      })
      
      // Discourse
      SpaceRow(localize.discourseTitle(), action: {
        selectedURL = URL(string: localize.discourseLink())
      })
    }
    .onChange(of: selectedURL) { newSelectedURL in
      isSafariPresented = (newSelectedURL != nil)
    }
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let selectedURL = selectedURL {
        Safari(url: selectedURL)
      }
    }
  }
}

struct SpaceRow: View {
  let text: String
  let action: () -> Void
  
  init(_ text: String, action: @escaping () -> Void) {
    self.text = text
    self.action = action
  }
  
  var body: some View {
    OutlineButton(
      text: text,
      smallAccessory: { Image.smArrowOut },
      action: action)
      .controlSize(.large)
  }
}
