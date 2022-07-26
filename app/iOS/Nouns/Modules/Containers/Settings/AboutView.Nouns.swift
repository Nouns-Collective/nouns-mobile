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

struct AboutNounsView: View {
  @Binding var isPresented: Bool
  
  @State private var isSafariPresented = false
  
  /// Holds a reference to the localized text.
  private let localize = R.string.aboutNouns.self
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      
      HStack(alignment: .top) {
        Image(R.image.noun.name)
          .padding(0)
          .offset(x: -20)
        
        Spacer()
        
        // Dismiss About Nouns.wtf
        SoftButton(
          icon: { Image.xmark },
          action: {
            withAnimation {
              isPresented.toggle()
            }
          })
      }
        
      // Content
      Text(localize.title())
        .font(.custom(.bold, relativeTo: .title2))
      
      Text(localize.nounsWtfDescription())
        .font(.custom(.regular, relativeTo: .subheadline))
        .lineSpacing(7)
      
      // Opens `nouns.wtf`
      SoftButton(
        text: localize.learnMore(),
        largeAccessory: { Image.web },
        action: { isSafariPresented.toggle() })
        .controlSize(.large)
        .padding(.top, 25)
    }
    .padding(20)
    .fullScreenCover(isPresented: $isSafariPresented) {
      if let url = URL(string: R.string.shared.nounsWebsite()) {
        Safari(url: url)
      }
    }
  }
}

struct AboutNounsView_Previews: PreviewProvider {
  
  static var previews: some View {
    Text("About")
      .background(Gradient.bubbleGum)
      .bottomSheet(isPresented: .constant(true)) {
        AboutNounsView(isPresented: .constant(false))
      }
      .onAppear {
        NounsUI.configure()
      }
  }
}
