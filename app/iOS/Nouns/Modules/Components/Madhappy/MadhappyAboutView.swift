// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

struct MadhappyAboutView: View {
  @State private var isSafariPresented: Bool = false
  @Binding var isPresented: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      HStack(alignment: .top) {
        HStack {
          NounPuzzle(seed: .init(background: 4, glasses: 3, head: 76, body: 6, accessory: 11))
          NounPuzzle(seed: .init(background: 6, glasses: 7, head: 184, body: 22, accessory: 31))
          NounPuzzle(seed: .init(background: 11, glasses: 14, head: 87, body: 14, accessory: 31))
          NounPuzzle(seed: .init(background: 2, glasses: 7, head: 174, body: 2, accessory: 19))
        }

        Spacer()
        
        // Dismiss
        SoftButton(
          icon: { Image.xmark },
          action: {
            withAnimation {
              isPresented.toggle()
            }
          })
      }
        
      // Content
      Text(R.string.madhappy.title())
        .font(.custom(.bold, relativeTo: .title2))
      
      Text(R.string.madhappy.description())
        .font(.custom(.regular, relativeTo: .subheadline))
        .lineSpacing(7)
      
      // Opens `https://madhappy.com`
      SoftButton(
        text: R.string.madhappy.learnMore(),
        largeAccessory: { Image.smArrowOut },
        action: {
          AppCore.shared.analytics.logEvent(withEvent: .openMadhappyWebsite, parameters: nil)
          isSafariPresented.toggle()
        })
        .controlSize(.large)
        .padding(.top, 25)
    }
    .padding(20)
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let url = URL(string: R.string.madhappy.website()) {
        Safari(url: url)
      }
    }
  }
}
