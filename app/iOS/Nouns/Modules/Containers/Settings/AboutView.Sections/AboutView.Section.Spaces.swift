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

      // Discourse
      SpaceRow(localize.discourseTitle(), action: {
        selectedURL = URL(string: localize.discourseLink())
      })
      
      // Twitter
      SpaceRow(localize.twitterTitle(), action: {
        selectedURL = URL(string: localize.twitterLink())
      })
      
      // Etherscan
      SpaceRow(localize.etherscanTitle(), action: {
        selectedURL = URL(string: localize.etherscanLink())
      })
    }
    .onChange(of: selectedURL) { newSelectedURL in
      isSafariPresented = (newSelectedURL != nil)
    }
    .fullScreenCover(
      isPresented: $isSafariPresented,
      onDismiss: {
        selectedURL = nil
        isSafariPresented = false
      },
      content: {
        if let selectedURL = selectedURL {
          Safari(url: selectedURL)
        }
      }
    )
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
