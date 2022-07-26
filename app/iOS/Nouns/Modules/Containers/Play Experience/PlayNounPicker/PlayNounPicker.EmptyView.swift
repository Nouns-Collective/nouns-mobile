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
import Services

extension PlayNounPicker {
    
  /// A placeholder view for when there are no nouns to choose
  /// from in the Play (`NounPlayground`) experience.
  struct EmptyView: View {
    
    ///
    let action: () -> Void
    
    ///
    @Environment(\.outlineTabViewHeight) private var tabBarHeight
    
    /// Holds a reference to the localized text.
    private let localize = R.string.playExperience.self
    
    var body: some View {
      VStack(alignment: .leading, spacing: 10) {
        Text(R.string.playExperience.noNouns())
          .font(.custom(.bold, relativeTo: .title2))
        
        Spacer()
        
        VStack(spacing: 0) {
          NounSpeechBubble(
            localize.createNounSpeechBubble(),
            noun: "un-noun", spacing: -60)
          
          OutlineButton(
            text: localize.createNoun(),
            largeAccessory: { Image.new },
            action: action)
            .controlSize(.large)
            .padding(.horizontal)
        }

        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun
      // card and the top of the tab view
      .padding(.bottom, 20)
    }
  }
}
